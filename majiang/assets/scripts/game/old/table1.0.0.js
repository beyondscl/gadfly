/***
 *【注意属性可能会被界面编辑器的数据初始化的时候覆盖】
 *
 * ***/

//这里是全局变量，考虑更改
var seatCards = {
    //example:
    // seatb: [
    //     {id:'',
    //     status:0,  //0 默认，1单机状态
    //     cNode:cc.Node}...
    // ],
    seatb: [],
    seatr: [],
    seatt: [],
    seatl: []
}
cc.Class({
    extends: cc.Component,

    properties: {
        // foo: {
        //    default: null,      // The default value will be used only when the component attaching
        //                           to a node for the first time
        //    url: cc.Texture2D,  // optional, default is typeof default
        //    serializable: true, // optional, default is true
        //    visible: true,      // optional, default is true
        //    displayName: 'Foo', // optional
        //    readonly: false,    // optional, default is false
        // },
        // ...
        status: 0,//位置状态

        resource: null, //加载获取资源相关
        scale: 0.8, //自己的14张牌的缩放比例

        //位置节点，用来画牌
        seatb: null, //位置下面，自己的位置
        seatr: null, //位置右边
        seatt: null,//位置上边
        seatl: null,//位置左边

        cardTab: {
            default: null,
            type: cc.Node
        },//当前出的是哪一张牌的动画
        seatCards: null,//四个位置的所有牌及其牌的状态

        mouseClickInter: 0.16,//双击事件的时间间隔 ,
        mouseClickStart: 0,//双击事件的毫秒开始时间
        mouseClickType: 0,//双击单击
        clickCard: null,//当前点击的牌
        clickCardX: 0, //由于点击事件，该牌位置已经移动，记录原始的位置
        clickCardY: 0, //或者通过该节点的兄弟节点计算坐标

    },

    // use this for initialization
    onLoad: function () {
        this.init();
    },
    initButtons: function () {

    },
    init: function () {//人员准备完成，初始化游戏界面
        this.resource = cc.find("game/bg").getComponent("resource");
        this.seatb = cc.find("game/table/bseat");
        this.seatr = cc.find("game/table/rseat");
        this.seatt = cc.find("game/table/useat");
        this.seatl = cc.find("game/table/lseat");
        this.initButtons();
        this.initMyCards();
        this.initRightSeat();
        this.initLeftSeat();
        this.initTopSeat();
        this.getCard();

    },
    initMyCards: function () {
        for (let i = 0; i < 13; i++) {
            cc.loader.loadRes("images/GameScence/0/handmah_" + this.initCards()[i], cc.SpriteFrame, function (Error, Asset) {
                let UUID = this.getUUID();
                let CardNode = new cc.Node(UUID);
                let sp = CardNode.addComponent(cc.Sprite);
                sp.spriteFrame = Asset;
                sp.sizeMode = cc.Sprite.SizeMode.CUSTOM;
                CardNode.id = this.initCards()[i];
                CardNode.setAnchorPoint(this.seatb.getAnchorPoint());
                CardNode.x = i * 65;
                CardNode.y = 0;
                CardNode.width = 83 * this.scale;
                CardNode.height = 125 * this.scale;
                this.seatb.addChild(CardNode);//添加节点
                seatCards.seatb[i] = {//初始化数据====================需要单独踢出去
                    id: UUID,
                    status: 0,
                    type: 0, //0 正常 1碰 3 吃 4 明杠1 5明杠2 6暗杠  明杠分为杠一家或者3家
                    cNode: CardNode
                };
                this.initEvent(CardNode);//初始化事件
            }.bind(this));
        }
    },
    initRightSeat: function () {
        for (let i = 0; i < 13; i++) {
            cc.loader.loadRes("images/GameScence/hand_right", cc.SpriteFrame, function (Error, Asset) {
                let CardNode = new cc.Node();
                let sp = CardNode.addComponent(cc.Sprite);
                sp.spriteFrame = Asset;
                sp.sizeMode = cc.Sprite.SizeMode.CUSTOM;
                CardNode.setAnchorPoint(this.seatb.getAnchorPoint());
                CardNode.x = 0;
                CardNode.y = (13 - i) * 23;
                CardNode.width = 24;
                CardNode.height = 60;
                this.seatr.addChild(CardNode);
            }.bind(this));
        }
    },
    initLeftSeat: function () {
        for (let i = 0; i < 13; i++) {
            cc.loader.loadRes("images/GameScence/hand_left", cc.SpriteFrame, function (Error, Asset) {
                let CardNode = new cc.Node();
                let sp = CardNode.addComponent(cc.Sprite);
                sp.spriteFrame = Asset;
                sp.sizeMode = cc.Sprite.SizeMode.CUSTOM;
                CardNode.setAnchorPoint(this.seatb.getAnchorPoint());
                CardNode.x = 0;
                CardNode.y = (13 - i) * 22;
                CardNode.width = 24;
                CardNode.height = 60;
                this.seatl.addChild(CardNode);
            }.bind(this));
        }
    },
    initTopSeat: function () {
        for (let i = 0; i < 13; i++) {
            cc.loader.loadRes("images/GameScence/hand_top", cc.SpriteFrame, function (Error, Asset) {
                let CardNode = new cc.Node();
                let sp = CardNode.addComponent(cc.Sprite);
                sp.spriteFrame = Asset;
                sp.sizeMode = cc.Sprite.SizeMode.CUSTOM;
                CardNode.setAnchorPoint(this.seatb.getAnchorPoint());
                CardNode.x = -(i + 1) * 38;
                CardNode.y = 0;
                CardNode.width = 40;
                CardNode.height = 59;
                this.seatt.addChild(CardNode);
            }.bind(this));
        }
    },
    getCard: function (cNode, _args) { //开始发牌，测试自己第一个
        let cardIndex = this.initCards()[Math.ceil(Math.random() * 14) - 1]; //0-13
        cc.loader.loadRes("images/GameScence/0/handmah_" + cardIndex, cc.SpriteFrame, function (Error, Asset) {
            let UUID = this.getUUID();
            let CardNode = new cc.Node(UUID);
            let sp = CardNode.addComponent(cc.Sprite);
            sp.spriteFrame = Asset;
            sp.sizeMode = cc.Sprite.SizeMode.CUSTOM;
            CardNode.id = cardIndex;
            CardNode.setAnchorPoint(this.seatb.getAnchorPoint());
            CardNode.x = 14 * 65;
            CardNode.y = 0;
            CardNode.width = 83 * this.scale;
            CardNode.height = 125 * this.scale;
            this.seatb.addChild(CardNode);//添加节点
            seatCards.seatb[13] = {//初始化数据====================需要单独踢出去
                id: UUID,
                status: 0,
                type: 0, //0 正常 1碰 3 吃 4 明杠1 5明杠2 6暗杠  明杠分为杠一家或者3家
                cNode: CardNode
            };
            this.initEvent(CardNode);//初始化事件
            this.setCards();
        }.bind(this));
    },
    //获取14张牌,模拟后台传入的真实牌数据
    initCards: function () {
        let CardIds = [11, 12, 13, 15, 16, 21, 22, 23, 24, 25, 31, 32, 33, 19];
        return CardIds;
    },
    initEvent: function (CardNode) {
        CardNode.on(cc.Node.EventType.TOUCH_END, function (Event) {
            let currTime = new Date().getMilliseconds();
            if (this.mouseClickStart == 0) {
                this.clickCard = CardNode;
                this.mouseClickType = 'ONE_EVENT'
                this.mouseClickStart = currTime;
                this.scheduleOnce(this.clickEvent, this.mouseClickInter);
            } else if ((currTime - this.mouseClickStart) / 1000 < this.mouseClickInter) {
                if (CardNode == this.clickCard) {
                    this.mouseClickType = 'DOUBLE_EVENT'
                    this.mouseClickStart = 0;
                    this.unschedule(this.clickEvent);
                    this.clickEvent();
                    this.downCards();
                } else {
                    this.unschedule(this.clickEvent);
                    this.clickCard = CardNode;
                    this.mouseClickType = 'ONE_EVENT';
                    this.scheduleOnce(this.clickEvent, this.mouseClickInter);
                }
            }
        }, this)
    },
    clickEvent: function () {
        if (!this.checkUser()) {
            return;
        }
        this.clickCardX = this.clickCard.x;
        this.clickCardY = this.clickCard.y;
        this.mouseClickStart = 0;
        this.nodeAction(this.clickCard, this.mouseClickType);
    },
    checkUser: function () {//判断当前出牌用户
        return true;
    },
    checkPeng: function () {

    },
    checkGang: function () {

    },
    checkDone: function () {  //是否赢了

    },
    downCards: function () {//使所有点击上移动的牌恢复原位,用于重复单击事件
        for (let c in seatCards.seatb) {
            c = parseInt(c);
            if (seatCards.seatb[c].status == 1) {
                seatCards.seatb[c].status = 0;
                seatCards.seatb[c].cNode.y -= 50;
            }
        }
    },
    doubleClickCb: function (CardNode, _Args) { //出牌，动作回调 CardNode ==this已经绑定
        //更改节点显示图片
        let id = CardNode.getComponent(cc.Sprite).spriteFrame.name.split("_")[1];
        let cardSf = cc.loader.getRes("/images/GameScence/0/mingmah_" + id, cc.SpriteFrame);
        if (cardSf) {
            CardNode.getComponent(cc.Sprite).spriteFrame = cardSf;
        } else {
            cc.log("get res error :" + id);
        }
        this.scheduleOnce(function () { //移动到出牌区域
            this.checkDone();
            this.checkGang();
            this.checkPeng();
            let showChuPaiNode = this.getShowCard(CardNode);
            var finished = cc.callFunc(this.chuPaiCb, this, []);
            var myAction = cc.sequence(cc.moveBy(0.3, showChuPaiNode.x, showChuPaiNode.y), cc.fadeOut(0.4), finished);
            CardNode.runAction(myAction);
        }, 0.4);
    },
    chuPaiCb: function (cNode, _Args) {
        cNode.destroy();
        let showChuPaiNode = this.getShowCard(cNode);
        showChuPaiNode.getComponent(cc.Sprite).spriteFrame = cNode.getComponent(cc.Sprite).spriteFrame;
        showChuPaiNode.active = true;
        //显示当前出的牌，需要判断坐标
        this.cardTab.x = showChuPaiNode.x + showChuPaiNode.width / 2;
        this.cardTab.y = showChuPaiNode.y + showChuPaiNode.height - 5;
        this.cardTab.active = true;
        this.sortCards("SORT_1", this.getNodeDetail(cNode).cNode, seatCards.seatb[13].cNode, seatCards.seatb);
    },
    /**
     * 这里主要处理牌的动画显示
     * 不处理逻辑，不处理数据，不处理算分等
     * @param Type  当前操作
     * 1.正常出牌 SORT_1
     * 2.碰 SORT_2
     * 3.杠 SORT_3
     *   3.1已经碰 + 摸一张 = 明杠 SORT_3_1
     *   3.2有三张 + 摸一张 = 暗杠 SORT_3_2
     *   3.2有三张 + 吃一张 = 明杠 SORT_3_3
     * @param cNode  当前操作的牌[出的牌]
     * @param oNode  当前操作的牌[收到的牌]
     * @param myCards  当前我的所有牌,包含了状态等
     *
     */
    sortCards: function (Type, cNode, oNode, myCards) {
        if (Type == "SORT_1") {  //正常出牌后
            if (cNode == oNode) { //出的牌是收到的牌
                this.getCard();
                return;
            }
            let clickCardX = 0;
            let clickCardY = 0;
            let widthX = 65;
            //cNode <--> oNode之间的数据应该左右移,不应该用id来判断，应该通过全局数组中取段操作
            var cNodeIndex = 0;//取值[0-12]
            var oNodeSmaIndex = -1; //取值[0-12]
            for (var c = 0; c < myCards.length; c++) { // 获取出牌的下标
                let ele = myCards[c];
                if (ele.id == cNode.name) { //==ele.cNode.name
                    cNodeIndex = c;
                    break;
                }
            }
            // 获取拿到牌应该放的下标
            //如果在已出牌的左边，那么下标该+1
            //如果在已出牌的又边，那么下标该不变
            for (var c = 0; c < myCards.length; c++) {
                let ele = myCards[c];
                if (ele.cNode.id < oNode.id) {
                    oNodeSmaIndex = c;
                } else {
                    break;
                }
            }
            if (cNodeIndex < oNodeSmaIndex) { //中间段向左移动
                oNodeSmaIndex = oNodeSmaIndex < 0 ? 0 : oNodeSmaIndex;
                oNodeSmaIndex = oNodeSmaIndex >= 12 ? 12 : oNodeSmaIndex;
                for (var c = 0; c < myCards.length; c++) {
                    if (c > cNodeIndex && c <= oNodeSmaIndex) {
                        clickCardX = myCards[oNodeSmaIndex].cNode.x; //获取坐标先，在移动
                        clickCardY = myCards[oNodeSmaIndex].cNode.y;
                        let moveAction = cc.moveTo(0.1, myCards[c].cNode.x - widthX, myCards[c].cNode.y);
                        myCards[c].cNode.runAction(moveAction);
                    }
                }
            }
            if (cNodeIndex > oNodeSmaIndex) { //中间段向右移动
                //解决第一个和最后一个的问题
                for (var c = 0; c < myCards.length; c++) {
                    if (c < cNodeIndex && c > oNodeSmaIndex) {  //cNodeIndex-oNodeSmaIndex大于1执行
                        oNodeSmaIndex = oNodeSmaIndex > 12 ? 12 : oNodeSmaIndex;
                        clickCardX = myCards[oNodeSmaIndex + 1].cNode.x;
                        clickCardY = myCards[oNodeSmaIndex + 1].cNode.y;
                        let moveAction = cc.moveTo(0.1, myCards[c].cNode.x + widthX, myCards[c].cNode.y);
                        myCards[c].cNode.runAction(moveAction);
                    }
                    if (cNodeIndex - oNodeSmaIndex == 1) {//cNodeIndex-oNodeSmaIndex==1执行
                        clickCardX = this.clickCardX;
                        clickCardY = this.clickCardY;
                        break;
                    }
                }
            }
            if (Math.abs(cNodeIndex - oNodeSmaIndex) == 0) { //这里 回调，位置已经改变，所以需要之前记录，不过也可以根据下标计算
                clickCardX = this.clickCardX;
                clickCardY = this.clickCardY;
            }
            var finished = cc.callFunc(this.getCard, this, []);//getCard作为测试，这样可以不断的获取到牌和出牌
            let moveAction = cc.sequence(
                cc.moveTo(0.3, oNode.x, oNode.y + 90),
                cc.moveTo(0.3, clickCardX, clickCardY),
                cc.fadeIn(1), finished);
            oNode.runAction(moveAction);
        }
    },
    //根据一个节点，在列表中获取其具体信息，比如状态等
    getNodeDetail: function (cNode) {
        for (let c in seatCards.seatb) {
            let ele = seatCards.seatb[c];
            if (ele.id == cNode.name) {
                return ele;
            }
        }
        cc.log("error getNodeDetail null!!!")
    }
    ,
    nodeAction: function (CardNode, Type) {
        CardNode = this.getNodeDetail(CardNode);
        if (Type == "ONE_EVENT") { //当前节点上提，恢复其他节点原始状态
            if (CardNode.status == 0) {
                this.downCards();
                CardNode.status = 1;
                CardNode.cNode.y += 50;
                return;
            }
            if (CardNode.status == 1) {
                CardNode.status = 0;
                CardNode.cNode.y -= 50;
                return;
            }
            if (CardNode.status == 3) {
                return;
            }
        }
        if (Type == "DOUBLE_EVENT") {
            this.downCards();
            //双击出牌->移动到指定位置隐藏->显示出的牌->移动显示的牌到出牌区域
            CardNode.status = 3;//出牌
            var finished = cc.callFunc(this.doubleClickCb, this, []);
            // var myAction = cc.sequence(cc.moveBy(0.3, 450 - CardNode.cNode.x, 160), cc.fadeOut(0.1), finished);
            var myAction = cc.sequence(cc.moveBy(0.3, 450 - CardNode.cNode.x, 160), finished);
            CardNode.cNode.runAction(myAction);
        }
    }
    ,
    getShowCard: function (CNode) {  //获取到出牌区域，当前应该显示的牌,
        let parentName = CNode.parent.name;
        let chuPaiNode = cc.find("game/bg/pic_zmhw/" + parentName);
        let cNodes = chuPaiNode.children;
        for (let c in cNodes) {
            if (cNodes[c].active == false) {
                return cNodes[c];
            }
        }
    }
    ,
    /***
     * 操作整体牌数组的方法
     * 因为拍会一直删除更新等
     */
    setCards: function () {
        // this.seatb = cc.find("game/table/bseat");
        // let newCards = this.seatb.children;
        // if(!newCards){return}
        // let seatCardsCopy = seatCards.seatb.concat();
        // for (var d = 0; d < newCards.length; d++) {
        //     let name = newCards[d].name;
        //     for (var c = 0; c < seatCardsCopy.length; c++) {
        //         let ele = seatCardsCopy[c];
        //         if (ele&&ele.id == name) {
        //             seatCards.seatb[d] = seatCardsCopy[c];
        //             break;
        //         }
        //     }
        // }
        this.testCheck();
    },
// called every frame, uncomment this function to activate update callback
    doNothing: function () {

    },
    testCheck: function () {
        for (let i = 0; i < seatCards.seatb.length; i++) {
            if (!seatCards.seatb[i]) {
                return;
            }
            if (seatCards.seatb[i].status == 3) {
                cc.log("error!!!!!!!!!!!!!!status====3")
            }
            console.log("移动后横坐标:" + seatCards.seatb[i].cNode.x);
        }
    }
    ,
    getUUID: function () {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    },
    update: function (dt) {
        //
    }
    ,
})
;
