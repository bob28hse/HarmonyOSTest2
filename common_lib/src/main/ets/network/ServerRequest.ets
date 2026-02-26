// Ensure these are at the very top of your ServerRequest.ets
import { rcp } from '@kit.RemoteCommunicationKit';
import { taskpool } from '@kit.ArkTS';
import { util } from '@kit.ArkTS'; // Required for TextDecoder


// This MUST be outside the class and marked @Concurrent
//@Concurrent
//async function decryptAndParseTask(buffer: ArrayBuffer): Promise<object> {
  // Use util.TextDecoder to convert bytes to string
  //let decoder = util.TextDecoder.create('utf-8');
  //let jsonString = decoder.decode(new Uint8Array(buffer));

  // Perform your 28Hse decryption here
  // let decrypted = myDecrypt(jsonString);

  //return JSON.parse(jsonString);
//}


export class ServerRequest {
  // Create the session once
  private static session = rcp.createSession();
  private static sessionCookie: string = "";

  // T for Model
  static async request(url: string): Promise<Record<string, Object>> {
    try {
      console.info("Start Request...");

      const request = new rcp.Request(url, "GET");

      if (ServerRequest.sessionCookie != "") {
        request.headers = {
          'cookie': ServerRequest.sessionCookie
        };
      }

      const response = await ServerRequest.session.fetch(request);

      const setCookie = response.headers['set-cookie'];
      console.info("Saved Cookie: " + setCookie);

      if (ServerRequest.sessionCookie == '' && setCookie) {
        ServerRequest.sessionCookie = Array.isArray(setCookie) ? setCookie.join('; ') : setCookie;
        console.info("[Session] Synced ID: " + ServerRequest.sessionCookie);
      }

      if (response.statusCode !== 200) {
        throw new Error(`HTTP_ERR_${response.statusCode}`);
      }

      // Check if body exists and convert to ArrayBuffer for TaskPools
      if (response.body) {
        // Use 'decodeToString' instead of 'decode' (Latest API 12/20 Standard)
        const decoder = util.TextDecoder.create('utf-8');
        const jsonString = decoder.decodeToString(new Uint8Array(response.body as ArrayBuffer));

        console.log("jsonString: ", jsonString);

        const result = JSON.parse(jsonString) as Record<string, Object>;

        // 'null' is for the replacer, '2' is the number of spaces for indentation
        console.info("[28Hse-Debug] Parsed Object: " + JSON.stringify(result, null, 2));

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
