import { Base_Model } from '../../../common/base/model';
import { HomeSearch_Model } from './HomeSearch_Model';
import { HomeDetail_Model } from './HomeDetail_Model';

export class Home_Model extends Base_Model<HomeSearch_Model, HomeDetail_Model> {
}