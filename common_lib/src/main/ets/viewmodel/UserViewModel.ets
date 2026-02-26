import { ServerRequest } from '../network/ServerRequest';
import { SegmentButtonV2Item } from '@kit.ArkUI';
import { StringUtils } from '../../../../Index';

@Observed
export class UserViewModel {
  @Track name: string = "";
  @Track isVip: boolean = false;
  @Track isLoading: boolean = false;

  async refreshProfile() {
    this.isLoading = true;
    try {
      // 1. Request data
      const data = await ServerRequest.request("https://www.28hse.com/init_app.php?ios_version_name=3.14.2.0&lang=zh");
      //const result = data as Record<string, Object>;
      const homeData = await ServerRequest.request("https://www.28hse.com");
      const homeData2 = homeData['data'] as Record<string, Object>;
      const homeData3 = homeData2['results'].toString();

      console.log(homeData3);

      const decrypted = StringUtils.aesDecryptJSON(homeData3, getContext());
      console.log(JSON.stringify(decrypted));

      // 2. Update properties - UI will refresh automatically
      //this.name = data.name;
      //this.isVip = data.isVip;
    } catch (e) {
      // Handle error (e.g., show toast)
    } finally {
      this.isLoading = false;
    }
  }
}