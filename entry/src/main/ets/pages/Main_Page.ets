import { UserViewModel } from 'common_lib';
import { Base_Model } from 'common_lib';

@Entry
@ComponentV2
export struct Main {
  @Local message: string = 'MainPage';
  @Local model: UserViewModel = new UserViewModel();

  @Local pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination(){
      RelativeContainer() {
        Text(this.message)
          .id('HelloWorld')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            this.message = 'Welcome2';


          })
      }
      .height('100%')
      .width('100%')
    }
    .onReady((context: NavDestinationContext) => {
      return;
      this.pathStack = context.pathStack;
      console.info('Current page ID: ' + context.pathInfo.name);

      //const sharedItem = this.pathStack.getParamByName("Main")[0] as Base_Model;
      const sharedItem = context.pathInfo.param as Base_Model;
      console.log("Main Page: " + sharedItem.slogan);
      console.log("Full: " + JSON.stringify(sharedItem));

      this.message = sharedItem.slogan;
    })
  }
}