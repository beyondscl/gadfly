/**
 * card节点上需要事件，那么它的大小不能为0.0
 * @type {Function}
 */
var card = cc.Class({
    extends: cc.Component,
    properties: {
        id: '',      //无意义的唯一编号,因为牌可以有完全重复
        status: 0,   //状态 0 收到牌，1单击状态
        cardType: 0, //在我的牌中，0普通牌，1碰，2杠 状态不够再加,-1表示碰，杠之后需要删除该节点
        cardLand: 0, //普通牌，鬼牌
        cardId: 0,   //用于获取资源，或者比较大小排序等
        cardName: '',//真实名称 比如:handOut_11
        cardImg: {
            default: null,
            type: cc.Node
        },
        cardGui: {
            default: null,
            type: cc.Node
        }
        //-----分割线-----
    },
    doInit: function (Id, CardId, CardName, cardImg, isGui) {
        this.id = Id;
        this.cardId = CardId;
        this.cardName = CardName;
        // this.node.children[0].getComponent(cc.Sprite).spriteFrame = cardImg;
        this.cardImg.getComponent(cc.Sprite).spriteFrame = cardImg;
        if (isGui == 1) {
            this.cardLand = 1;
            this.cardGui.active = true;
        }
    },

    // use this for initialization
    onLoad: function () {
        // this.node.on(cc.Node.EventType.TOUCH_END, this.touch)
    },

    // called every frame, uncomment this function to activate update callback
    // update: function (dt) {

    // },
    // touch: function () {
    //
    // },
});
