import { BaseInitedDataRequest, BaseRequest, ServerRequest } from '../network/ServerRequest';
import { StringUtils } from '../utils/StringUtils';
import { Base_Model } from '../model/Base_Model'
import { JSON } from '@kit.ArkTS';
import { UserModel } from '../model/UserModel';

@ObservedV2
export class Base_ViewModel {
  // @Trace ensures any View bound to these will update instantly
  @Trace public isLoading: boolean = false;
  @Trace public errorMessage: string = '';

  @Trace item?: Base_Model;

  async refreshProfile() {
    this.isLoading = true;
    try {
      // 1. Request data
      const params: Record<string, string> = {
        'ios_version_name': '3.14.2.0',
        'lang': 'zh'
      };
      const data = await ServerRequest.request("https://www.28hse.com/init_app.php", params);

      const testSearch = await ServerRequest.request("https://www.28hse.com/en/property/dosearch");
      const testResult = testSearch.data as BaseInitedDataRequest;
      const d1 = await StringUtils.aesDecryptJSON<UserModel>(testResult.results as string);
      //console.log("Test: " + JSON.stringify(d1));
      console.log("UserModel: " + d1?.buyRent);

      //const homeData = await ServerRequest.request("https://www.28hse.com");
      //const decrypted = await StringUtils.aesDecryptJSON<Base_Model>(homeData.data as string);
      //console.log("Slogan: " + decrypted?.slogan);


    } catch (e) {
      // Handle error (e.g., show toast)
    } finally {
      this.isLoading = false;
    }
  }
}