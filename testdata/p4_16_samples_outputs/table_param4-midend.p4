#include <core.p4>

control c(inout bit<32> arg) {
    bit<32> x_0;
    @name("a") action a() {
    }
    @name("b") action b() {
    }
    @name("t") table t_0() {
        key = {
            x_0: exact;
        }
        actions = {
            a();
            b();
        }
        default_action = a();
    }
    action act() {
        arg = x_0;
        x_0 = arg;
    }
    action act_0() {
        arg = x_0;
    }
    action act_1() {
        arg = x_0;
        arg = arg + 32w1;
    }
    action act_2() {
        arg = x_0;
    }
    action act_3() {
        x_0 = arg;
    }
    table tbl_act() {
        actions = {
            act_3();
        }
        const default_action = act_3();
    }
    table tbl_act_0() {
        actions = {
            act();
        }
        const default_action = act();
    }
    table tbl_act_1() {
        actions = {
            act_0();
        }
        const default_action = act_0();
    }
    table tbl_act_2() {
        actions = {
            act_1();
        }
        const default_action = act_1();
    }
    table tbl_act_3() {
        actions = {
            act_2();
        }
        const default_action = act_2();
    }
    apply {
        tbl_act.apply();
        switch (t_0.apply().action_run) {
            a: {
                tbl_act_0.apply();
                t_0.apply();
                tbl_act_1.apply();
            }
            b: {
                tbl_act_2.apply();
            }
            default: {
                tbl_act_3.apply();
            }
        }

    }
}

control proto(inout bit<32> arg);
package top(proto p);
top(c()) main;