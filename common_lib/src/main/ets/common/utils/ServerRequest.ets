import { rcp } from '@kit.RemoteCommunicationKit';
import { util, url as urlLib } from '@kit.ArkTS';

// Common API JSON
export interface BaseInitedDataRequest {
  msg: string | null;
  results: Object;
  encrypt: number;
}

export interface BaseDebugRequest {
  debug_notes: string[];
}

export interface BaseRequest {
  status: number;
  result: number;
  data: Object; //Record<string, Object>;
  encrypt: number;
  debug: BaseDebugRequest;
  platform: string;
}

export class ServerRequest {

  // Create the session ONCE; Configuration is for EVERY REQUEST unless overrides by request
  private static sessionConfig: rcp.SessionConfiguration = {

  };
  private static session = rcp.createSession(ServerRequest.sessionConfig);
  private static sessionCookie: string = "";

  // TODO future: Interceptors for dynamic logic

  // T for Model
  static async request(url: string, params?: Record<string, string>, method: string = 'POST'): Promise<BaseRequest> {
    try {
      // TODO: Guard invalid parameters

      console.info("Start Request...");

      // Construct the URL based on params
      const safeParams = params ?? {};
      const urlParams = new urlLib.URLParams();
      Object.keys(safeParams).forEach(key => {
        urlParams.append(key, safeParams[key]);
      })
      const finalUrl = `${url}?${urlParams.toString()}`;

      // RCP request (no header for request)
      const request = new rcp.Request(finalUrl, method);

      // Cookie preserving, since RCP is stateless
      if (ServerRequest.sessionCookie != "") {
        request.headers = {
          'cookie': ServerRequest.sessionCookie
        };
      }
      console.log('2nd header: ' + JSON.stringify(request.headers));

      // Fetch AFTER ALL SETUP
      const response = await ServerRequest.session.fetch(request);

      // Get cookies for preserving sessionID (for 1st time)
      if (ServerRequest.sessionCookie == '') {
        const setCookie = response.headers['set-cookie'];
        console.info("Saved Cookie: " + setCookie);

        if (setCookie) {
          ServerRequest.sessionCookie = Array.isArray(setCookie) ? setCookie.join('; ') : setCookie;
          console.info("[Session] Synced ID: " + ServerRequest.sessionCookie);
        }
      }

      if (response.statusCode !== 200) {
        throw new Error(`HTTP_ERR_${response.statusCode}`);
      }

      // Check if body exists and convert to ArrayBuffer for TaskPools
      if (response.body) {
        // Use 'decodeToString' instead of 'decode'
        const decoder = util.TextDecoder.create('utf-8');
        const jsonString = decoder.decodeToString(new Uint8Array(response.body as ArrayBuffer));
        console.log("jsonString: ", jsonString);

        const result = JSON.parse(jsonString) as BaseRequest;
        console.info("Parsed Object: " + JSON.stringify(result, null, 2));

        return result;
      }

      throw new Error("EMPTY_RESPONSE");
    } catch (err) {
      console.error(`Fetch Error: ${JSON.stringify(err)}`);
      throw err as Error;
    }
  }

  // Add this for clean app exit or module disposal
  static destroy() {
    if (ServerRequest.session) {
      ServerRequest.session.close();
      console.info("RCP Session closed successfully.");
    }
  }
}
