import { BaseInitedDataRequest, ServerRequest, decryptAndParseTask, InitConst } from '../../utils';
import { Base_Model, BaseSearch_Model, BaseDetail_Model } from '../model';
import { JSON, taskpool } from '@kit.ArkTS';

@ObservedV2
export class Base_ViewModel<T extends Base_Model<BaseSearch_Model, BaseDetail_Model>> {
  // @Trace ensures any View bound to these will update instantly
  @Trace isLoading: boolean = false;
  @Trace errorMessage: string = '';
  @Trace status: string = "Idle";

  @Trace item?: T;

  async refreshProfile() {
    this.isLoading = true;
    try {
      // 1. Request data
      const params: Record<string, string> = {
        'ios_version_name': '3.14.2.0',
        'lang': 'zh'
      };
      const data = await ServerRequest.request("https://www.28hse.com/init_app.php", params);
      const homeData = await ServerRequest.request("https://www.28hse.com");
      console.log("Home: " + homeData.encrypt.toString());

      const testSearch = await ServerRequest.request("https://www.28hse.com/en/property/dosearch");
      console.log("List: " + testSearch.encrypt.toString());

      const testResult = testSearch.data as BaseInitedDataRequest;
      const testResultString = testResult.results as string;
      console.log("Start decrypting...");

      const task = new taskpool.Task(
        decryptAndParseTask,
        testResultString,
        InitConst.AES_KEY,
        InitConst.AES_IV
      );

      // We 'await' here, but notice the FrameCounter in the UI keeps moving!
      const result = await taskpool.execute(task);
      console.log("Finished Decrypt: " + JSON.stringify(result));

      //const d1 = await StringUtils.aesDecryptJSON<UserModel>(testResult.results as string);
      //console.log("Test: " + JSON.stringify(d1));
      //console.log("UserModel: " + d1?.buyRent);

      //const homeData = await ServerRequest.request("https://www.28hse.com");
      //const decrypted = await StringUtils.aesDecryptJSON<Base_Model>(homeData.data as string);
      //console.log("Slogan: " + decrypted?.slogan);


    } catch (err) {
      // Handle error (e.g., show toast)
      console.error("View Model Error:", err.message, err.stack);
      throw err as Error;
    } finally {
      this.isLoading = false;
    }
  }
}