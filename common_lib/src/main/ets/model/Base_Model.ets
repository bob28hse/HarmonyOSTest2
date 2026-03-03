@ObservedV2
export class Base_Model {
  // Essentials properties
  @Trace id: string = '';
  @Trace url: string = '';

  // Detail properties
  @Trace slogan: string = '';

  constructor (id: string, url: string) {
    this.id = id;
    this.url = url;
  }
}