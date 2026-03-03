import { Base_ViewModel } from 'common_lib';
import { Main } from './Main_Page'

@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello World';
  @Local model: Base_ViewModel = new Base_ViewModel();

  pageStack: NavPathStack = new NavPathStack();

  @Builder
  PageMap(name: string) {
    if (name === 'Main') {
      Main()
    }
  }

  build() {
    Navigation(this.pageStack) {
      RelativeContainer() {
        Text(this.message)
          .id('HelloWorld')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(async () => {
            this.message = 'Welcome';
            await this.model.refreshProfile();

            const data: Record<string, string | number> = {
              "info": "Hello",
              "count": 1
            };

            this.pageStack.pushPathByName('Main', this.model.item);
          })
      }
      .height('100%')
      .width('100%')
    }
    .navDestination(this.PageMap)
    .title("Index")
  }
}