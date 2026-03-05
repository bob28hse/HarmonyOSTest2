import { Splash_ViewModel } from 'common_lib';
import * as AllPages from '../features'

// Standard Entry Point == Splash!
// onReady default is async => do not await since will block UI
@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Splash Screen';
  @Local count: number = 0;

  @Local pathStack: NavPathStack = new NavPathStack();
  @Local viewModel: Splash_ViewModel = new Splash_ViewModel();

  // Method 1 using PagesMap for swapping layout (e.g. SquareFoot)
  // Method 2 using route_map for Lazy Loads
  @Builder
  PageMap(name: string) {
    if (name === 'Home') {
      AllPages.HomePage();
    }
    if (name === 'Schoolnet') {
      AllPages.SchoolNetPage();
    }
  }

  aboutToAppear(): void {
    this.viewModel.requestData();
  }

  build() {
    Navigation(this.pathStack) {
      RelativeContainer() {
        Text(this.message)
          .id('SplashId')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(async () => {
            this.message = 'Clicked Splash';

            // TODO Pass splash screen related
            this.pathStack.pushPathByName('Home', undefined);
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
    .navDestination(this.PageMap)
    .title("Index")
  }
}