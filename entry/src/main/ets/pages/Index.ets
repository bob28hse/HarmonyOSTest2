import * as AllPages from '../features'

// Standard Entry Point == Splash!
@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello World';
  @Local count: number = 0;

  pageStack: NavPathStack = new NavPathStack();

  // Method 1 using PagesMap for swapping layout (e.g. SquareFoot)
  // Method 2 using route_map for Lazy Loads
  @Builder
  PagesMap(name: string) {
    if (name === 'Home') {
      AllPages.HomePage();
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
            // TODO Pass splash screen related
            this.pageStack.pushPathByName('Home', undefined);

            this.message = 'Welcome';
            //await this.model.refreshProfile();
            //console.log("Finish Refreshing");

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
    .navDestination(this.PagesMap)
    .title("Index")
  }
}