const base_url = "http://139.177.182.102:9090/api";

const login_url = "$base_url/customer/auth/token/request";
const delete_customer_url = "$base_url/customer/delete";
const change_password_url = "$base_url/customer/change/password";
const register_url = "$base_url/customer/create";

const food_by_id_url = "$base_url/menu/";
const food_by_category_url = "$base_url/menu/by-category/";
const popular_meals_url = "$base_url/menu/popular";
const food_category_list_url = "$base_url/menu/category/list";
const food_list_url = "$base_url/menu/list";

const search_food_url = "$base_url/menu/search?query=";

const make_order_url = "$base_url/customer/order/create";
const get_order_by_id_url = "$base_url/customer/order/";
const get_order_items_url = "$base_url/customer/order/items/";
const get_order_owned_url = "$base_url/customer/order/history/list";

const customer_virtual_account = "$base_url/customer/virtual-account";
const customer_virtual_account_balance = "$base_url/customer/virtual-account/balance";
const customer_order_make_payment = "$base_url/customer/order/make/payment";
const customer_payment_status = "$base_url/customer/order/payment/status";

const card_payment_verification = "$base_url/customer/order/card/payment";