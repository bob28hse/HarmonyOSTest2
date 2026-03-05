import { Schoolnet_ViewModel, Schoolnet_ListItem } from "common_lib";

@ComponentV2
export struct SchoolNetPage {
  @Local message: string = 'School Net Page';
  @Local count: number = 0;

  @Local pathStack: NavPathStack = new NavPathStack();
  @Local viewModel: Schoolnet_ViewModel = new Schoolnet_ViewModel();

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

          })
        Button(`${this.count}`, { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .height(40)
          .onClick(() => {
            this.count++;
          })

        List() {
          Repeat(this.viewModel.items)
            .each((listChild) => {
              ListItem() {
                // if objects too large, then should pass required param
                Schoolnet_ListItem(listChild.item)
              }
            })
            .key((item) => item.id.toString())
        }
      }
      .height('100%')
      .width('100%')
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
      console.info('Current page ID: ' + context.pathInfo.name);

      const result = this.viewModel.initializeModelList();
    })
  }
}