// 个人中心左侧菜单配置
List userAsideMenuConfig = [
  {
    'name': '账号管理',
    'path': '/user',
    'icon': '0xe88a',
    'children': [
      {'name': '个人资料', 'path': '/user/info', 'authority': 'admin'},
      {'name': '安全设置', 'path': '/user/secure', 'authority': 'admin'},
      {'name': '会员邀请', 'path': '/user/invite', 'authority': 'admin'},
      {'name': '地址管理', 'path': '/user/address', 'authority': 'admin'},
    ],
  },
  {
    'name': '订单管理',
    'path': '/order',
    'icon': '0xe85d',
    'children': [
      {'name': '我的订单', 'path': '/order/list', 'authority': 'admin'},
    ],
  },
  {
    'name': '分享金',
    'path': '/share',
    'icon': '0xe227',
    'children': [
      {'name': '分享用户', 'path': '/share/user', 'authority': 'admin'},
      {'name': '分享查询', 'path': '/share/info', 'authority': 'admin'},
    ],
  },
  {
    'name': '金融管理',
    'path': '/financial',
    'icon': '0xe263',
    'children': [
      {'name': '金融申请', 'path': '/financial/apply/user', 'authority': 'admin'},
    ],
  },
];

// 商家管理左侧菜单配置
//const sellerAsideMenuConfig = [
//  {
//    'name': '店铺概览',
//    'path': '/shop/overview',
//    'icon': 'bell',
//    'authority': 'admin',
//  },
//  {
//    'name': '店铺管理',
//    'path': '/shop',
//    'icon': 'home2',
//    'children': [
//      { 'name': '店铺设置', 'path': '/shop/info', 'authority': 'admin' },
//      { 'name': '商品分类', 'path': '/shop/class', 'authority': 'admin' },
//    ],
//  },
//  {
//    'name': '会员管理',
//    'path': '/shop',
//    'icon': 'fans',
//    'children': [
//      { 'name': '会员列表', 'path': '/shop/member', 'authority': 'admin' },
//    ],
//  },
//  {
//    'name': '商品管理',
//    'path': '/goods',
//    'icon': 'compass',
//    'children': [
//      { 'name': '商品发布', 'path': '/goods/new', 'authority': 'admin' },
//      { 'name': '商品列表', 'path': '/goods/list', 'authority': 'admin' },
//    ],
//  },
//  {
//    'name': '订单管理',
//    'path': '/orders',
//    'icon': 'person',
//    'children': [
//      { 'name': '新建订单', 'path': '/orders/new', 'authority': 'admin' },
//      { 'name': '订单列表', 'path': '/orders/list', 'authority': 'admin' },
//    ],
//  },
//  {
//    'name': '金融管理',
//    'path': '/financial',
//    'icon': 'mail',
//    'children': [
//      { 'name': '金融申请', 'path': '/financial/apply/seller', 'authority': 'admin' },
//    ],
//  },
//];
//
//// 后台左侧菜单
//const adminAsideMenuConfig = [
//  {
//    'name': '控制台',
//    'path': '/dashboard',
//    'icon': 'home2',
//    'authority': 'admin',
//  },
//  {
//    'name': '平台配置',
//    'path': '/config',
//    'icon': 'shezhi',
//    'children': [
//      { 'name': '轮播配置', 'path': '/config/slider', 'authority': 'admin' },
//    ],
//  },
//  {
//    'name': '用户管理',
//    'path': '/user',
//    'icon': 'chart1',
//    'children': [
//      { 'name': '新增用户', 'path': '/user/new', 'authority': 'admin' },
//      { 'name': '用户列表', 'path': '/user/list', 'authority': 'admin' },
//    ],
//  },
//  {
//    'name': '商品管理',
//    'path': '/goods',
//    'icon': 'table',
//    'children': [
//      { 'name': '商品分类', 'path': '/goods/class', 'authority': 'admin' },
//      { 'name': '商品列表', 'path': '/goods/list', 'authority': 'admin' },
//    ],
//  },
//  {
//    'name': '订单管理',
//    'path': '/orders',
//    'icon': 'ul-list',
//    'children': [
//      { 'name': '订单列表', 'path': '/orders/list', 'authority': 'admin' },
//    ],
//  },
//  {
//    'name': '金融管理',
//    'path': '/financial',
//    'icon': 'publish',
//    'children': [
//      { 'name': '金融审批', 'path': '/financial/approval', 'authority': 'admin' },
//    ],
//  },
//  {
//    'name': '营销管理',
//    'path': '/marketing',
//    'icon': 'result',
//    'children': [
//      { 'name': '广告列表', 'path': '/marketing/ad', 'authority': 'admin' },
//    ],
//  },
//];
