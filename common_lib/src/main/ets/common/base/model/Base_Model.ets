import { BaseSearch_Model } from "./BaseSearch_Model";
import { BaseDetail_Model } from "./BaseDetail_Model";
import { JsonUtils } from "../../utils";

// Factory: based on what needs to be passed into the Constructor of those Generic class
type SearchFactory<S> = (data: Record<string, Object>) => S;
type DetailFactory<D> = (data: Record<string, Object>) => D;

@ObservedV2
export class Base_Model<Search extends BaseSearch_Model, Detail extends BaseDetail_Model> {
  // Essentials properties
  @Trace id: number = 0;
  @Trace url: string = '';

  @Trace search: Search | null = null;
  @Trace detail: Detail | null = null;

  // for ViewModel/Repository creating it
  // (if Interface => no need, it directs)
  // (JSON.parse & as => lost all the functions of class)
  constructor(
    data: Record<string, Object>,
    searchFactory: SearchFactory<Search>,
    detailFactory: DetailFactory<Detail>
  ) {
    this.id = JsonUtils.getNumber(data, "id");
    this.url = JsonUtils.getString(data, "search_url");

    // Pass the correct sub-json to Factory
    this.search = searchFactory(data);
    this.detail = detailFactory(data);
  }
}
