import { ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { formBindingData, formInfo, formProvider } from '@kit.FormKit';
import getCarInfo from '../api/car';
import CardInfo from '../type/CardInfo';
import { rpc } from '@kit.IPCKit';
import { BusinessError } from '@kit.BasicServicesKit';

const DOMAIN = 0x0000;

class MyParcelable implements rpc.Parcelable {
  num: number;
  str: string;

  constructor(num: number, str: string) {
    this.num = num;
    this.str = str;
  }

  marshalling(messageSequence: rpc.MessageSequence): boolean {
    messageSequence.writeInt(this.num);
    messageSequence.writeString(this.str);
    return true;
  }

  unmarshalling(messageSequence: rpc.MessageSequence): boolean {
    this.num = messageSequence.readInt();
    this.str = messageSequence.readString();
    return true;
  }
}


export default class EntryAbility extends UIAbility {
  onCreate(want: Want): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    this.updateInfo(want)
    this.callee.on('updateCarInfo', (data: rpc.MessageSequence) => {
      interface callParams {
        formId?: string;
      }
      const params = JSON.parse(data.readString()) as callParams
      hilog.fatal(0, 'text', 'formId: ' + params.formId)
      if (params.formId) {
        this.updateCard(params.formId)
      }
      return new MyParcelable(1, 'ok');
    })
  }

  onNewWant(want: Want): void {
    this.updateInfo(want)
  }

  onDestroy(): void {
    this.callee.off('updateCarInfo');
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');let windowClass: window.Window = windowStage.getMainWindowSync(); // 获取应用主窗口
      // 1. 设置窗口全屏
      let isLayoutFullScreen = true;
      windowClass.setWindowLayoutFullScreen(isLayoutFullScreen).then(() => {
        console.info('Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
      });
      let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR; // 以导航条避让为例
      let avoidArea = windowClass.getWindowAvoidArea(type);
      let bottomRectHeight = avoidArea.bottomRect.height; // 获取到导航条区域的高度
      AppStorage.setOrCreate('bottomRectHeight', bottomRectHeight);

      type = window.AvoidAreaType.TYPE_SYSTEM; // 以状态栏避让为例
      avoidArea = windowClass.getWindowAvoidArea(type);
      let topRectHeight = avoidArea.topRect.height; // 获取状态栏区域高度
      AppStorage.setOrCreate('topRectHeight', topRectHeight);
      // 3. 注册监听函数，动态获取避让区域数据
      windowClass.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          let topRectHeight = data.area.topRect.height;
          AppStorage.setOrCreate('topRectHeight', topRectHeight);
        } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          let bottomRectHeight = data.area.bottomRect.height;
          AppStorage.setOrCreate('bottomRectHeight', bottomRectHeight);
        }
      });
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  private updateInfo(want: Want) {
    if (!want || !want.parameters || want.parameters[formInfo.FormParam.IDENTITY_KEY] === undefined) {
      AppStorage.setOrCreate('formId', '');
      return;
    }
    AppStorage.setOrCreate('formId', want.parameters![formInfo.FormParam.IDENTITY_KEY].toString());
  }


  private updateCard(formId: string) {
    const token = AppStorage.get<string>('token')
    if (formId && token) {
      getCarInfo(token).then(res => {
        const obj: CardInfo = {
          cardStatus: 1,
          carInfo: res
        }
        formProvider.updateForm(formId, formBindingData.createFormBindingData(obj))
      }).catch((e: Error) => {
        const obj: CardInfo = {
          cardStatus: 2
        }
        formProvider.updateForm(formId, formBindingData.createFormBindingData(obj))
      })
        .finally(() => {
          this.context.terminateSelf();
        })
    } else {
      const obj: CardInfo = {
        cardStatus: 2,
        carInfo: {}
      }
      formProvider.updateForm(formId, formBindingData.createFormBindingData(obj))
        .then(() => {
          this.context.terminateSelf();
        })
    }
  }
}