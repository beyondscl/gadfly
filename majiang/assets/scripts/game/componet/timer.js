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
        difen: {
            default: null,
            type: cc.Label
        },
        roomType: {
            default: null,
            type: cc.Label
        },
        lastCardsNum: {
            default: null,
            type: cc.Label
        },
        lastGameNum: {
            default: null,
            type: cc.Label
        },
        lastTime: {
            default: null,
            type: cc.Label
        },
        timerTotal: 15,

    },

    // use this for initialization
    onLoad: function () {
        this.cardCountDown();
    },
    doInit: function () {

    },
    // called every frame, uncomment this function to activate update callback
    // update: function (dt) {

    // },

    //外部调用
    reReckon: function () {
        this.unschedule(this.reckon);
        this.timerTotal = 16;
        this.lastTime.string = this.timerTotal;
        this.reckon();
    },
    reckon: function () {
        this.timerTotal -= 1;
        this.lastTime.string = this.timerTotal;
        this.schedule(this.reckon, 1, 14, 0);
        this.resetTime();
        //do something
    },
    resetTime: function () {
        if (this.timerTotal == 0) {
            this.timerTotal = 15;
            this.lastTime.string = this.timerTotal;
        }
    },
    cardCountDown: function () {
        this.lastCardsNum.string = this.lastCardsNum.string - 1
    }


});
