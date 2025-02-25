import { CustomContentDialog, LoadingDialog, PromptAction } from '@kit.ArkUI';
import { formBindingData, formProvider } from '@kit.FormKit';
import { common } from '@kit.AbilityKit';
import getCarInfo from '../api/car';
import CardInfo from '../type/CardInfo';
import { sendablePreferences } from '@kit.ArkData';

PersistentStorage.persistProp('token', '');

@Entry
@Component
struct Index {
  private uiContext: UIContext = this.getUIContext()
  private promptAction: PromptAction = this.uiContext.getPromptAction()
  @StorageProp('bottomRectHeight')
  bottomRectHeight: number = 0;
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;
  @StorageProp('token') token: string = '';
  @StorageProp('formId') formId: string = '';
  @State inputToken: string = '';
  @State inputTokenVisible: boolean = false;

  build() {
    Flex({
      direction: FlexDirection.Column
    }) {
      Row() {
        Text('I have A MG')
          .fontSize('30vp')
          .width('100%')
          .fontWeight('600')
      }
      .padding({
        left: 12,
        right: 12
      })

      List() {
        ListItem() {
          Button() {
            Row() {
              Column() {
                Text('Token')
                  .fontColor($r('sys.color.ohos_id_color_text_primary'))
              }
              Column() {
                Row() {
                  Text(this.token ? '已设置' : '未设置')
                    .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                    .fontSize(14)
                  SymbolGlyph($r('sys.symbol.chevron_right'))
                    .fontColor([$r('sys.color.ohos_id_color_text_tertiary')])
                    .fontSize(24)
                    .opacity(.5)
                    .margin({left: 4})
                }
              }
            }
            .width('100%')
            .padding(16)
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {
              this.inputToken = this.token
              // this.dialogController.open()
              this.inputTokenVisible = true
            })
          }
          .type(ButtonType.Normal)
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .bindSheet($$this.inputTokenVisible, this.TokenInputComponent(), {
            title: {title: '设置Token'},
            height: 200 + px2vp(this.bottomRectHeight),
            blurStyle: BlurStyle.Thin
          })
        }
        .backgroundColor($r('sys.color.ohos_fa_list_card_bg'))
        .borderRadius(20)
        .clip(true)
      }
      .width('100%')
      .height('100%')
      .align(Alignment.TopStart)
      .padding(20)
    }
    .height('100%')
    .width('100%')
    .padding({
      top: px2vp(this.topRectHeight) + 12,
    })
    .backgroundColor($r('sys.color.ohos_id_container_color'))
  }

  dialogControllerProgress: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({
      content: '正在获取数据, 请稍候',
    }),
  })
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.TokenInputComponent();
      },
    }),
    width: '100%',
    alignment: DialogAlignment.Bottom,
    cornerRadius: {bottomLeft: 0, bottomRight: 0},
    offset: {dy: px2vp(this.bottomRectHeight), dx: 0}
  });
  // 自定义弹出框的内容区
  @Builder
  TokenInputComponent(): void {
    Column() {
      Row() {
        TextInput({
          text: this.inputToken,
          placeholder: '请输入token'
        })
          .defaultFocus(true)
          .onChange((value: string) => {
            this.inputToken = value
          })
          .onSubmit(() => {
            AppStorage.setOrCreate('token', this.inputToken)
            this.inputTokenVisible = false
            this.updateCard()
          })
      }
      .width('100%')
      Row() {
        Button('确定', {
          type: ButtonType.Capsule
        })
          .width('100%')
          .fontColor($r('sys.color.brand'))
          .backgroundColor($r('sys.color.color_sidebarcontainer_sub_bg'))
          .onClick(() => {
            AppStorage.setOrCreate('token', this.inputToken)
            this.inputTokenVisible = false
            this.updateCard()
          })
      }
      .margin({top: 16})
      .width('100%')
    }
    .width('100%')
    .padding(20)
  }
  private updateCard() {
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    AppStorage.setOrCreate('token', this.token)
    sendablePreferences.getPreferences(context, { name: 'carInfoStore' }).then(db => {
      db.putSync('token', this.token)
      db.flush()
    })
    if (this.formId) {
      this.dialogControllerProgress.open()
      getCarInfo(this.token).then(res => {
        const obj: CardInfo = {
          formId: this.formId,
          cardStatus: 1,
          carInfo: res
        }
        formProvider.updateForm(this.formId, formBindingData.createFormBindingData(obj))
          .then(() => {
            context.terminateSelf()
          })
      }).catch((e: Error) => {
        this.promptAction.showToast({
          message: `获取信息失败([${e.name}]${e.message})`
        })
      })
        .finally(() => {
          this.dialogControllerProgress.close()
        })
    } else {
      this.promptAction.showToast({
        message: "保存成功"
      })
    }
  }
}