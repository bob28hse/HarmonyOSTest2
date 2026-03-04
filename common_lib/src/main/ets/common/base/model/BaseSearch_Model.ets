import { JsonUtils } from "../../utils";

@ObservedV2
export class BaseSearch_Model {
  @Trace title: string = '';
  @Trace desc: string = '';

  // TODO coverPic
  constructor (data: Record<string, Object>) {
    this.title = JsonUtils.getString(data, "search_title");
    this.desc = JsonUtils.getString(data, "search_desc");
  }
}