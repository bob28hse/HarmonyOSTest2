import { ServerRequest } from '../network/ServerRequest';
import { SegmentButtonV2Item } from '@kit.ArkUI';
import { StringUtils } from '../../../../Index';

@ObservedV2
export class UserViewModel {
  @Trace isLoading: boolean = false;

  async refreshProfile() {
    this.isLoading = true;
    try {
      const url = "";
      const data = await ServerRequest.request(url);

    } catch (e) {
      // Handle error (e.g., show toast)
    } finally {
      this.isLoading = false;
    }
  }
}