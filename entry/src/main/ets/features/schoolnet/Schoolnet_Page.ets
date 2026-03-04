@ComponentV2
export struct SchoolNetPage {
  @Local message: string = 'School Net Page';
  @Local count: number = 0;

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
      return;

    })
  }
}