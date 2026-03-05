import { Base_Model, JsonUtils } from '../../../common';
import { SchoolnetSearch_Model } from './SchoolnetSearch_Model';
import { SchoolnetDetail_Model } from './SchoolnetDetail_Model';

@ObservedV2
export class Schoolnet_Model extends Base_Model<SchoolnetSearch_Model, SchoolnetDetail_Model> {
  @Trace district: string = '';
  @Trace name: string = '';
  @Trace tags: string[] = [];

  constructor(data: Record<string, Object>) {
    super(data, (d) => new SchoolnetSearch_Model(d), (d) => new SchoolnetDetail_Model(d));

    this.district = JsonUtils.getString(data, 'district');
    this.name = JsonUtils.getString(data, 'name');

    const tagObjects = JsonUtils.getArray(data, 'detail_tags');
    for (const tagObject of tagObjects) {
      this.tags.push(JsonUtils.getString(tagObject, 'name'));
    }
  }
}