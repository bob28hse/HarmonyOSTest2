import { Schoolnet_Model } from "../model";
import { Base_ViewModel } from "../../../common";

export class Schoolnet_ViewModel extends Base_ViewModel<Schoolnet_Model>{

  protected override getFactory(): (data: Record<string, Object>) => Schoolnet_Model {
    return (d) => new Schoolnet_Model(d);
  }

  protected override getUrl(): string {
    return "https://www.28hse.com/en/schoolnet/dosearch";
  }

}