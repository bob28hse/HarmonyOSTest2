import { JsonUtils } from "../../utils";

@ObservedV2
export class BaseDetail_Model {
  @Trace title: string = '';
  @Trace desc: string = '';
  @Trace modifiedTime: string = '';

  // TODO detailPic
  constructor(data: Record<string, Object>) {
    this.title = JsonUtils.getString(data, "title");
    this.desc = JsonUtils.getString(data, "desc");
    this.modifiedTime = JsonUtils.getString(data, "detail_modifiedtime");
  }
}