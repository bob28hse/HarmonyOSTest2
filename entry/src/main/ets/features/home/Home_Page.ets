import { Home_ViewModel } from "common_lib";

// Suppose here will receive a bunch of ApiUrls (after initApp in Splash)
// => save into GlobalKeys / pass to the next page viewModel
// => onReady to construct the page
@ComponentV2
export struct HomePage {
  @Local message: string = 'Home Page';
  @Local count: number = 0;

  @Local pathStack: NavPathStack = new NavPathStack();
  @Local viewModel: Home_ViewModel = new Home_ViewModel();

  build() {
    NavDestination(){
      RelativeContainer() {
        Text(this.message)
          .id('HomeId')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            this.message = 'Clicked Home';

            this.pathStack.pushPathByName('Schoolnet', undefined);
          })
        Button(`${this.count}`, { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .height(40)
          .onClick(() => {
            this.count++;
          })
      }
      .height('100%')
      .width('100%')
    }
    .onReady((context: NavDestinationContext) => {
      //context.pathInfo.param;
      this.pathStack = context.pathStack;
      console.info('Current page ID: ' + context.pathInfo.name);

      this.viewModel.requestData();
    })
  }
}