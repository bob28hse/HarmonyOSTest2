import { Home_Model } from "../model";
import { Base_ViewModel } from "../../../common";

// Temp, inaccurate
export class Home_ViewModel extends Base_ViewModel<Home_Model>{

  protected override getFactory(): (data: Record<string, Object>) => Home_Model {
    return (d) => new Home_Model(d);
  }

  protected override getUrl(): string {
    return "https://www.28hse.com/en";
  }

  protected override getParams(): Record<string, string> {
    return {};
    return {
      'ios_version_name': '3.14.2.0',
      'lang': 'zh'
    };
  }
}