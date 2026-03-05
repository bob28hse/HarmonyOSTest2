import { Base_Model } from '../../../common';
import { HomeSearch_Model } from './HomeSearch_Model';
import { HomeDetail_Model } from './HomeDetail_Model';

@ObservedV2
export class Home_Model extends Base_Model<HomeSearch_Model, HomeDetail_Model> {

  constructor(data: Record<string, Object>) {
    super(data, (d) => new HomeSearch_Model(d), (d) => new HomeDetail_Model(d));


  }
}