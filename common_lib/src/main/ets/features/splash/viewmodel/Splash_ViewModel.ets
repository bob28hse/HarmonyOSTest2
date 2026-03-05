import { ServerRequest } from '../../../common';
import { JSON } from '@kit.ArkTS';

// TEMP
@ObservedV2
export class Splash_ViewModel {
  @Trace isLoading: boolean = false;

  async requestData(): Promise<Record<string, Object>> {
    this.isLoading = true;
    try {
      // URL and Param construction, Data fetching and decryption, Passing to model constructor
      // => should all be in Repository (now just for testing)

      const url = "https://www.28hse.com/init_app.php";
      const params: Record<string, string> = {
        'ios_version_name': '3.14.2.0',
        'lang': 'zh'
      };
      const rawJson = await ServerRequest.request(url, params);
      console.log("Raw Json: " + rawJson.encrypt.toString());

      // InitApp format is different
      let result = rawJson.data;

      console.log("Result Json: " + JSON.stringify(result));
      return result;

    } catch (err) {
      console.error("View Model Error:", err.message, err.stack);
      throw err as Error;
    } finally {
      this.isLoading = false;
    }
  }
}