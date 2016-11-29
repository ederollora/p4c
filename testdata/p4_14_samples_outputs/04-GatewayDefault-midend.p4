#include <core.p4>
#include <v1model.p4>

struct ingress_metadata_t {
    bit<8>  drop;
    bit<8>  egress_port;
    bit<8>  f1;
    bit<16> f2;
    bit<32> f3;
    bit<64> f4;
}

header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> ethertype;
}

struct metadata {
    @name("ing_metadata") 
    ingress_metadata_t ing_metadata;
}

struct headers {
    @name("ethernet") 
    ethernet_t ethernet;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("start") state start {
        packet.extract<ethernet_t>(hdr.ethernet);
        transition accept;
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("NoAction_2") action NoAction_0() {
    }
    @name("nop") action nop_0() {
    }
    @name("e_t1") table e_t1() {
        actions = {
            nop_0();
            NoAction_0();
        }
        key = {
            hdr.ethernet.srcAddr: exact;
        }
        default_action = NoAction_0();
    }
    apply {
        e_t1.apply();
    }
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("NoAction_3") action NoAction_1() {
    }
    @name("NoAction_4") action NoAction_7() {
    }
    @name("NoAction_5") action NoAction_8() {
    }
    @name("NoAction_6") action NoAction_9() {
    }
    @name("nop") action nop_1() {
    }
    @name("nop") action nop_6() {
    }
    @name("nop") action nop_7() {
    }
    @name("nop") action nop_8() {
    }
    @name("ing_drop") action ing_drop_0() {
        meta.ing_metadata.drop = 8w1;
    }
    @name("set_f1") action set_f1_0(bit<8> f1) {
        meta.ing_metadata.f1 = f1;
    }
    @name("set_f2") action set_f2_0(bit<16> f2) {
        meta.ing_metadata.f2 = f2;
    }
    @name("set_f2") action set_f2_2(bit<16> f2) {
        meta.ing_metadata.f2 = f2;
    }
    @name("set_f3") action set_f3_0(bit<32> f3) {
        meta.ing_metadata.f3 = f3;
    }
    @name("set_f3") action set_f3_2(bit<32> f3) {
        meta.ing_metadata.f3 = f3;
    }
    @name("set_egress_port") action set_egress_port_0(bit<8> egress_port) {
        meta.ing_metadata.egress_port = egress_port;
    }
    @name("set_f4") action set_f4_0(bit<64> f4) {
        meta.ing_metadata.f4 = f4;
    }
    @name("i_t1") table i_t1() {
        actions = {
            nop_1();
            ing_drop_0();
            set_f1_0();
            set_f2_0();
            set_f3_0();
            set_egress_port_0();
            NoAction_1();
        }
        key = {
            hdr.ethernet.dstAddr: exact;
        }
        default_action = NoAction_1();
    }
    @name("i_t2") table i_t2() {
        actions = {
            nop_6();
            set_f2_2();
            NoAction_7();
        }
        key = {
            hdr.ethernet.dstAddr: exact;
        }
        default_action = NoAction_7();
    }
    @name("i_t3") table i_t3() {
        actions = {
            nop_7();
            set_f3_2();
            NoAction_8();
        }
        key = {
            hdr.ethernet.dstAddr: exact;
        }
        default_action = NoAction_8();
    }
    @name("i_t4") table i_t4() {
        actions = {
            nop_8();
            set_f4_0();
            NoAction_9();
        }
        key = {
            hdr.ethernet.dstAddr: exact;
        }
        default_action = NoAction_9();
    }
    apply {
        switch (i_t1.apply().action_run) {
            default: {
                i_t4.apply();
            }
            nop_1: {
                i_t2.apply();
            }
            set_egress_port_0: {
                i_t3.apply();
            }
        }

    }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit<ethernet_t>(hdr.ethernet);
    }
}

control verifyChecksum(in headers hdr, inout metadata meta) {
    apply {
    }
}

control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

V1Switch<headers, metadata>(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;