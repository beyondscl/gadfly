/**
 * author:Leng Tingxue
 * time:2017/10/25
 * doc:
 */
var util = require("util");
util = new util();
cc.Class({
    extends: cc.Component,

    properties: {
        //桌子组件
        //不是Node
        table: cc.Node,
        //用户节点
        players: cc.Node,

        //收牌区域
        seatb: null,
        seatr: null,
        seatt: null,
        seatl: null,
        //出牌区域
        sendSeatb: null,
        sendSeatr: null,
        sendSeatt: null,
        sendSeatl: null,

        //大小缩放
        scale: 0.8,

        mouseClickInter: 0.5,//双击事件的时间间隔 ,
        mouseClickStart: 0,//双击事件的毫秒开始时间
        mouseClickType: 0,//双击单击
        clickCard: null,//当前点击的牌

        cardTab: cc.Node,//指示当前出的是哪一张牌的动画
        currentDoUser: -1, //当前出牌的用户
        currentSendCard: -1, //当前出的牌
        cardFlag: 0,//牌的标志位，0正常摸牌，1等待碰，2等待杠，3胡

        timerNode: cc.Node,//计时器
        timerJs: cc.Component,//计时器

        computerSendCardInter: 1, //电脑出牌间隔时间
    },

    start: function () {

    },
    initCB: function () {
        this.initTable();
        this.initCard();
        this.getNextUser();
        this.getCard();
    },
    //出牌用户
    getNextUser: function () {
        this.currentDoUser += 1;
        this.currentDoUser = this.currentDoUser == 4 ? 0 : this.currentDoUser;
    },
    initTable: function () {
        var table = cc.find("game/table");
        this.table = table.getComponent("table");
        this.seatb = this.table.receSeat[0];
        this.seatr = this.table.receSeat[1];
        this.seatt = this.table.receSeat[2];
        this.seatl = this.table.receSeat[3];
        this.sendSeatb = this.table.sendSeat[0];
        this.sendSeatr = this.table.sendSeat[1];
        this.sendSeatt = this.table.sendSeat[2];
        this.sendSeatl = this.table.sendSeat[3];
        this.cardTab = this.table.animalCardTab;
        this.timerNode = cc.find("game/table/timer");
        this.timerJs = this.timerNode.getComponent("timer");
    },
    //初始化牌
    initCard: function () {
        this.initMyCards();
        this.initRightSeat(13);
        this.initTopSeat(13);
        this.initLeftSeat(13);
    },
    initMyCards: function () {
        this.initBootomCards(this.initCards());
    },
    initRightSeat: function (count) {
        var childres = this.seatr.children;
        for (var i = 0; i < childres.length; i++) {
            childres[i].destroy();
        }
        for (let i = 0; i < count; i++) {
            let cardSf = cc.loader.getRes("images/GameScence/hand_right", cc.SpriteFrame);
            this.appendNewCard(this.seatr, cardSf, 0, (13 - i) * 23);
        }
    },
    initLeftSeat: function (count) {
        var childres = this.seatl.children;
        for (var i = 0; i < childres.length; i++) {
            childres[i].destroy();
        }
        for (let i = 0; i < count; i++) {
            let cardSf = cc.loader.getRes("images/GameScence/hand_left", cc.SpriteFrame);
            this.appendNewCard(this.seatl, cardSf, 0, (13 - i) * 23);
        }
    },
    initTopSeat: function (count) {
        var childres = this.seatt.children;
        for (var i = 0; i < childres.length; i++) {
            childres[i].destroy();
        }
        for (let i = 0; i < count; i++) {
            let cardSf = cc.loader.getRes("images/GameScence/hand_top", cc.SpriteFrame);
            this.appendNewCard(this.seatt, cardSf, -i * 38, 0, 40, 59);
        }
    },
    //新建节点，添加到指定节点
    appendNewCard: function (parentNode, spriteFrame, x, y, w=24, h=60) {
        let CardNode = new cc.Node();
        let sp = CardNode.addComponent(cc.Sprite);
        sp.spriteFrame = spriteFrame;
        sp.sizeMode = cc.Sprite.SizeMode.CUSTOM;
        CardNode.setAnchorPoint(parentNode.getAnchorPoint());
        CardNode.x = x;
        CardNode.y = y;
        CardNode.width = w;
        CardNode.height = h;
        parentNode.addChild(CardNode);
    },
    //新建节点，添加到指定节点
    appendNewPfCard: function (parentNode, spriteFrame, cardId, x, y) {
        let UUID = util.getUUID();
        let CardNode = cc.instantiate(cc.loader.getRes("prefabs/card", cc.Prefab)); //用里面的js初始化更好
        let cardJs = CardNode.getComponent("card");
        cardJs.doInit(UUID, cardId, "handmah_" + cardId, spriteFrame);
        CardNode.setAnchorPoint(this.seatb.getAnchorPoint());
        CardNode.id = cardId;
        CardNode.x = x;
        CardNode.y = y;
        parentNode.addChild(CardNode);//添加节点
        this.initEvent(CardNode);//初始化事件;
        return CardNode;
    },
    //获取14张牌,模拟后台传入的真实牌数据
    initCards: function () {
        let CardIds = [11, 11, 13, 13, 16, 16, 22, 22, 24, 24, 31, 32, 33];
        return CardIds;
    },
    //------------------------------------------------------------------------------------------------------------------
    //初始化事件
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
    //点击事件
    clickEvent: function () {
        if (this.currentDoUser != 0) {
            console.log("小伙别着急，没轮到你出牌呢!");
            return;
        }
        this.mouseClickStart = 0;
        this.nodeAction(this.clickCard, this.mouseClickType);
    },
    //事件动画
    nodeAction: function (CardNode, Type) {
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
            var myAction = cc.sequence(cc.moveBy(0.3, 450 - CardNode.x, 160), finished);
            CardNode.runAction(myAction);
        }
    },
    //事件动画
    doubleClickCb: function (CardNode, _Args) { //出牌，动作回调 CardNode ==this已经绑定
        //更改节点显示图片
        let id = CardNode.getComponent("card").cardId;
        let cardSf = cc.loader.getRes("/images/GameScence/0/mingmah_" + id, cc.SpriteFrame);
        if (cardSf) {
            CardNode.children[0].getComponent(cc.Sprite).spriteFrame = cardSf;
        } else {
            cc.log("get res error :" + id);
        }

        this.scheduleOnce(function () { //移动到出牌区域
            let showChuPaiNode = this.getShowCard();
            var finished = cc.callFunc(this.chuPaiCb, this, []);
            var myAction = cc.sequence(cc.moveBy(0.3, showChuPaiNode.x, showChuPaiNode.y), cc.fadeOut(0.4), finished);
            CardNode.runAction(myAction);
        }, 0.4);
    },
    //事件动画，回调
    chuPaiCb: function (cNode, _Args) {
        // cNode.destroy();
        let showChuPaiNode = this.getShowCard();
        showChuPaiNode.getComponent(cc.Sprite).spriteFrame = cNode.children[0].getComponent(cc.Sprite).spriteFrame;
        showChuPaiNode.active = true;
        //显示当前出的牌，需要判断坐标
        this.cardTab.parent = showChuPaiNode.parent;//建议采用父节点相同，不然后面各个节点会不显示
        this.cardTab.x = showChuPaiNode.x + showChuPaiNode.width / 2;
        this.cardTab.y = showChuPaiNode.y + showChuPaiNode.height + 10;
        this.sortCards(cNode);//牌排序
        this.getNextUser();//获取下一个操作人
        this.getCard();//发下一张牌
    },
    //获取到出牌区域，当前应该显示的牌,
    getShowCard: function () {
        let cNodes = this.sendSeatb.children;
        for (let c in cNodes) {
            if (cNodes[c].active == false) {
                return cNodes[c];
            }
        }
    },
    //出牌前，将所有牌下放
    downCards: function () {//使所有点击上移动的牌恢复原位,用于重复单击事件
        // for (let c in this.seatb) {
        //     c = parseInt(c);
        //     if (this.seatb[c].status == 1) {
        //         this.seatb[c].status = 0;
        //         this.seatb[c].cNode.y -= 50;
        //     }
        // }
    },
    //------------------------------------------------------------------------------------------------------------------
    checkUser: function () {
        return true;
    },
    //用户摸牌
    getCard: function () {
        if (this.cardFlag != 0) {
            console.log("当前不允许发牌，等待" + this.cardFlag);
            return;
        }
        this.timerJs.cardCountDown();//记牌
        this.timerJs.reReckon();//计时
        let cardIndex = this.initCards()[Math.ceil(Math.random() * 13) - 1]; //0-13
        if (this.currentDoUser == 0) {  //下，右，上，左
            let cardSf = cc.loader.getRes("images/GameScence/0/handmah_" + cardIndex, cc.SpriteFrame);
            this.appendNewPfCard(this.seatb, cardSf, cardIndex, 14 * 65, 0)
        }
        //出牌动画略过
        if (this.currentDoUser == 1) {
            this.initRightSeat(14);
            this.scheduleOnce(function () {
                for (let i = 0; i < this.sendSeatr.children.length; i++) {
                    let child = this.sendSeatr.children[i];
                    if (child.active == false) {
                        let cardIndex = this.initCards()[Math.ceil(Math.random() * 14) - 1]; //0-13
                        this.userShowCard(child, this.sendSeatr, cardIndex, 1);//1==right
                        break;
                    }
                }
            }, this.computerSendCardInter);
        }
        if (this.currentDoUser == 2) {
            this.initTopSeat(14);
            this.scheduleOnce(function () {
                for (let i = 0; i < this.sendSeatt.children.length; i++) {
                    let child = this.sendSeatt.children[i];
                    if (child.active == false) {
                        let cardIndex = this.initCards()[Math.ceil(Math.random() * 14) - 1]; //0-13
                        this.userShowCard(child, this.sendSeatt, cardIndex, 2);//1==right
                        break;
                    }
                }
            }, this.computerSendCardInter);
        }
        if (this.currentDoUser == 3) {
            this.initLeftSeat(14);
            this.scheduleOnce(function () {
                for (let i = 0; i < this.sendSeatl.children.length; i++) {
                    let child = this.sendSeatl.children[i];
                    if (child.active == false) {
                        let cardIndex = this.initCards()[Math.ceil(Math.random() * 14) - 1]; //0-13
                        this.userShowCard(child, this.sendSeatl, cardIndex, 3);//1==right
                        break;
                    }
                }
            }, this.computerSendCardInter);
        }
    },
    //用户出牌
    userShowCard: function (originCard, parent, cardIndex, position) {
        //指示动画位置
        var cardTabX = 0;
        var cardTabY = 0;
        if (position == 1) {//right
            cardTabX = originCard.x - originCard.width / 2;
            cardTabY = originCard.y + originCard.height / 2;
        }
        if (position == 2) {//top
            cardTabX = originCard.x;
            cardTabY = originCard.y + originCard.height;
        }
        if (position == 3) {//left
            cardTabX = originCard.x - originCard.width / 2;
            cardTabY = originCard.y + originCard.height / 2;
        }
        let cardSF = cc.loader.getRes("images/GameScence/0/mingmah_" + cardIndex, cc.SpriteFrame);//我的平躺显示
        let cardSF2 = cc.loader.getRes("images/GameScence/" + position + "/mingmah_" + cardIndex, cc.SpriteFrame);
        originCard.getComponent(cc.Sprite).spriteFrame = cardSF2;

        let UUID = util.getUUID();
        let CardNode = new cc.Node(UUID);//显示给我看的牌
        let sp = CardNode.addComponent(cc.Sprite);
        sp.spriteFrame = cardSF;
        sp.sizeMode = cc.Sprite.SizeMode.CUSTOM;
        CardNode.setAnchorPoint(this.sendSeatr.getAnchorPoint());
        CardNode.x = 0;
        CardNode.y = 0;
        CardNode.width = 83 * this.scale;
        CardNode.height = 125 * this.scale;
        parent.addChild(CardNode);

        this.scheduleOnce(function () {
            CardNode.active = false;
            CardNode.destroy();
            originCard.active = true;
            //显示当前出的牌，需要判断坐标
            this.cardTab.parent = parent;//建议采用父节点相同，不然后面各个节点会不显示
            this.cardTab.x = cardTabX;
            this.cardTab.y = cardTabY;
            //
            this.currentSendCard = cardIndex;
            this.getNextUser();
            this.initRightSeat(13);
            this.checkGame();
            this.getCard();
        }, this.computerSendCardInter);
    },
    /**
     *  重排我的牌:
     *  删除就节点，全部重新初始化新节点
     * 这里主要处理牌的动画显示
     * 不处理逻辑，不处理数据，不处理算分等
     * @param Type  当前操作
     * 1.正常出牌 0
     * 2.碰 1
     * 3.杠 2
     *   3.1已经碰 + 摸一张 = 明杠 SORT_3_1
     *   3.2有三张 + 摸一张 = 暗杠 SORT_3_2
     *   3.2有三张 + 吃一张 = 明杠 SORT_3_3
     * @param cNode  当前操作的牌[出的牌]
     *
     */
    sortCards: function (cNode) {
        var childres = this.seatb.children;
        var cardIds = [];
        for (var i = 0; i < childres.length; i++) {
            if (childres[i].getComponent("card").id != cNode.getComponent("card").id) {
                cardIds[cardIds.length] = childres[i].getComponent("card").cardId;
            }
            childres[i].active = false;
            childres[i].destroy();
        }
        cardIds = cardIds.sort();
        this.initBootomCards(cardIds);
    },
    /**
     *初始化我的所有牌
     * @param cardIds 需要初始化牌的id 和类型
     */
    initBootomCards: function (cardIds) {
        for (let i = 0; i < cardIds.length; i++) {
            let cardSf = cc.loader.getRes("images/GameScence/0/handmah_" + cardIds[i], cc.SpriteFrame);
            let CardNode = this.appendNewPfCard(this.seatb, cardSf, cardIds[i], i * 65, 0);
        }
    },
    doNothing: function () {

    },
    checkGame: function () {
        this.checkDone();
        this.checkPengGang();
    },
    checkDone: function () {

    },
    checkPengGang: function () {
        let childrens = this.seatb.children;
        let index = 0;
        for (let i = 0; i < childrens.length; i++) {
            if (childrens[i].id == this.currentSendCard) {
                index++
            }
        }
        //需要记录当前的牌，特效后隐藏,碰条件我没判断，起手不能碰
        if (index == 2) {
            this.cardFlag = 1;
            cc.log("小伙别急，我碰" + this.currentSendCard);
            this.table.buttonsPan.active = true;
            var btns = this.table.buttons;//guo,pneg,gang,hu
            btns[0].active = true;
            btns[1].active = true;
        }
        if (index == 3) {
            this.cardFlag = 2;
            cc.log("小伙别急，我杠" + this.currentSendCard);
            var btns = this.table.buttons;//guo,pneg,gang,hu
            btns[2].active = true;
        }
        if (index == 2 || index == 3) {
            this.scheduleOnce(function () {
                this.cardFlag = 0;
                this.getCard();
                this.table.buttonsPan.active = false;
            }, 5);
        }
    },
    //碰，就在自己牌列表中标致一张状态为碰，删除一个元素
    //碰，就在自己牌列表中标致一张状态为杠，删除2个元素
    doAnimal: function (Type) {
        var childres = this.seatb.children;
        var count = 0;
        for (var i = 0; i < childres.length; i++) { //设置标致位
            let cardJs = childres[i].getComponent("card");
            if (cardJs.cardId == this.currentSendCard) {
                if (Type == 1 && count < 2) {//碰
                    if (count == 0) {
                        cardJs.cardType = Type;
                    } else {
                        cardJs.cardType = -1;
                    }
                    count++;
                }
                if (Type == 2 && count < 3) {//杠
                    cardJs.cardType = count == 0 ? Type : cardJs.cardType;
                    if (count == 0) {
                        cardJs.cardType = Type;
                    } else {
                        cardJs.cardType = -1;
                    }
                    count++;
                }
            }
        }
        for (var i = 0; i < childres.length; i++) { //设置标致位
            console.log(childres[i].getComponent("card").cardType);
        }
    }
});
