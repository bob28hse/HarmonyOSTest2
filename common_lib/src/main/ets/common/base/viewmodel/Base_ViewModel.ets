import { ServerRequest, decryptAndParseTask, InitConst, JsonUtils } from '../../utils';
import { Base_Model, BaseSearch_Model, BaseDetail_Model } from '../model';
import { JSON, taskpool } from '@kit.ArkTS';

// It is now a ListViewModel - TODO
@ObservedV2
export class Base_ViewModel<T extends Base_Model<BaseSearch_Model, BaseDetail_Model>> {
  // @Trace ensures any View bound to these will update instantly
  @Trace isLoading: boolean = false;
  @Trace errorMessage: string = '';
  @Trace items: T[] = [];

  /**
   * This is the function the derived class MUST override.
   * It returns the "How to create T" logic.
   */
  protected getFactory(): (data: Record<string, Object>) => T {
    throw new Error("getFactory() must be implemented in the derived class");
  }

  protected getUrl(): string {
    return "";
  }

  protected getParams(): Record<string, string> {
    return {};
  }

  //(data: Array<Record<string, Object>>) {
  async initializeModelList() {
    console.time('modelTimer');
    const data = await this.requestData();
    console.timeLog('modelTimer');
    const dataItems = JsonUtils.getArray(data, 'Items');
    const factory = this.getFactory();
    this.items = dataItems.map(item => factory(item));
    console.log('Initialize Success!');
    console.timeEnd('modelTimer');
  }

  async requestData(): Promise<Record<string, Object>> {
    this.isLoading = true;
    try {
      // URL and Param construction, Data fetching and decryption, Passing to model constructor
      // => should all be in Repository (now just for testing)

      // 1. Request data (technically ServerRequest should also do in Taskpool)
      const url = this.getUrl();
      const params = this.getParams();
      const rawJson = await ServerRequest.request(url, params);
      console.log("Raw Json: " + rawJson.encrypt.toString());

      // InitApp format is different
      let result = rawJson.data;

      // Requires decrypt!
      if (rawJson.encrypt != 0) {
        const rawJsonResults = JsonUtils.getString(rawJson.data, 'results');
        console.log("Start Decrypting: " + rawJsonResults);

        const task = new taskpool.Task(
          decryptAndParseTask,
          rawJsonResults,
          InitConst.AES_KEY,
          InitConst.AES_IV
        );
        result = await taskpool.execute(task) as Record<string, Object>;
        console.log("Finished Decryption!");
      }

      return result;

      // --OLD-- (JSON
      //const d1 = await StringUtils.aesDecryptJSON<UserModel>(testResult.results as string);

    } catch (err) {
      console.error("View Model Error:", err.message, err.stack);
      throw err as Error;
    } finally {
      this.isLoading = false;
    }
  }
}