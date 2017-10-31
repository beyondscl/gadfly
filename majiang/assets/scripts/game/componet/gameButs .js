/**
 * 少用计时器，能用动画延迟就用动画，它包含了事件等
 */

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
        chiNode: cc.Node,
        pengNode: cc.Node,
        gangNode: cc.Node,
        guoNode: cc.Node,
        huNode: cc.Node,
        table: cc.Node,
        tableJs: cc.Component,
        gameJs: cc.Component,
    },

    // use this for initialization
    onLoad: function () {
        // this.chiNode.on(cc.Node.EventType.TOUCH_END, this.chi);
        this.pengNode.on(cc.Node.EventType.TOUCH_END, this.peng, this);
        this.gangNode.on(cc.Node.EventType.TOUCH_END, this.gang, this);
        this.guoNode.on(cc.Node.EventType.TOUCH_END, this.guo, this);
        this.huNode.on(cc.Node.EventType.TOUCH_END, this.hu, this);
        this.table = cc.find("game/table");
        this.tableJs = this.table.getComponent("table");
        this.table = cc.find("game/table");
        this.gameJs = cc.find("game").getComponent("gameStart");
    },

    // called every frame, uncomment this function to activate update callback
    // update: function (dt) {

    // },
    gang: function () {
        cc.log("gang");
        this.tableJs.gang.x = 0;
        this.tableJs.gang.y = -150;
        this.tableJs.gang.active = true;
        this.tableJs.gang.parent = this.table;
        this.tableJs.buttonsPan.active = false;
        let cb = cc.callFunc(this.doBtnCb, this.tableJs.gang, [])
        this.tableJs.gang.runAction(cc.sequence(cc.delayTime(1), cb));
    },
    peng: function () {
        cc.log("peng");
        this.tableJs.peng.x = 0;
        this.tableJs.peng.y = -150;
        this.tableJs.peng.active = true;
        this.tableJs.peng.parent = this.table;
        this.tableJs.buttonsPan.active = false;
        let cb = cc.callFunc(this.doBtnCb, this, []);
        this.tableJs.peng.runAction(cc.sequence(cc.delayTime(1), cb));
    },
    guo: function () {
        cc.log("guo");
        this.tableJs.buttonsPan.active = false;
    },
    chi: function () {

    },
    hu: function () {

    },
    doBtnCb: function (abThis) {
        this.tableJs.peng.active = false;
        this.gameJs.doAnimal(1);
    },
});
