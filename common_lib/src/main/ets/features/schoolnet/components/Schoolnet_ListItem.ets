@ComponentV2
export struct Schoolnet_ListItem {
  @Param name: string = "";
  @Param district: string = "";
  @Param tags: string[] = [];

  build() {
    Column() {
      Text(this.name)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .margin({ bottom: 4 })

      Text(this.district)
        .fontSize(14)
        .fontColor('#999999')
        .margin({ bottom: 10 })

      // Handles wrapping
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.tags, (tag: string) => {
          Text(tag)
            .fontSize(12)
            .fontColor('#666666')
            .backgroundColor('#F2F2F2')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(4)
            .margin({ right: 6, bottom: 6 }) // This creates the "gap"
        })
      }
      .margin({ bottom: -6 }) // This prevents the last row of tags from adding extra padding to the cell
    }
    .padding({ left: 16, right: 16, top: 18, bottom: 18 })
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .backgroundColor(Color.White)
  }
}
