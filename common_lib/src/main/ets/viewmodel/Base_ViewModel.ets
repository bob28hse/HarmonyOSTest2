import { ServerRequest } from '../network/ServerRequest';
import { StringUtils } from '../../../../Index';

@ObservedV2
export class Base_ViewModel {
  // @Trace ensures any View bound to these will update instantly
  @Trace public isLoading: boolean = false;
  @Trace public errorMessage: string = '';

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
      const homeData2 = homeData['data'] as Record<string, Object>;
      const homeData3 = homeData2['results'].toString();

      console.log(homeData3);

      const decrypted = StringUtils.aesDecryptJSON<Record<string, Object>>(homeData3);

    } catch (e) {
      // Handle error (e.g., show toast)
    } finally {
      this.isLoading = false;
    }
  }
}