<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan6" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_1" />
        <signal name="XLXN_2" />
        <signal name="XLXN_3" />
        <signal name="XLXN_4" />
        <signal name="XLXN_8" />
        <signal name="gpmc_clk_i" />
        <signal name="gpmc_n_we" />
        <signal name="gpmc_n_oe" />
        <signal name="gpmc_n_adv_ale" />
        <signal name="sys_clk_P" />
        <signal name="gpmc_a(10:1)" />
        <signal name="gpmc_n_cs(6:0)" />
        <signal name="gpio_in(7:0)" />
        <signal name="gpmc_d(15:0)" />
        <signal name="gpio_o(7:0)" />
        <signal name="PRT_O(15:0)" />
        <signal name="XLXN_17(15:0)" />
        <signal name="XLXN_21(15:0)" />
        <signal name="XLXN_23(1:0)" />
        <port polarity="Input" name="gpmc_clk_i" />
        <port polarity="Input" name="gpmc_n_we" />
        <port polarity="Input" name="gpmc_n_oe" />
        <port polarity="Input" name="gpmc_n_adv_ale" />
        <port polarity="Input" name="sys_clk_P" />
        <port polarity="Input" name="gpmc_a(10:1)" />
        <port polarity="Input" name="gpmc_n_cs(6:0)" />
        <port polarity="Input" name="gpio_in(7:0)" />
        <port polarity="BiDirectional" name="gpmc_d(15:0)" />
        <port polarity="Output" name="gpio_o(7:0)" />
        <port polarity="Output" name="PRT_O(15:0)" />
        <blockdef name="gpmc_wishbone">
            <timestamp>2016-12-8T10:0:42</timestamp>
            <rect width="64" x="400" y="20" height="24" />
            <line x2="464" y1="32" y2="32" x1="400" />
            <line x2="0" y1="-608" y2="-608" x1="64" />
            <line x2="0" y1="-544" y2="-544" x1="64" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <rect width="64" x="0" y="-236" height="24" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="464" y1="-608" y2="-608" x1="400" />
            <line x2="464" y1="-512" y2="-512" x1="400" />
            <line x2="464" y1="-416" y2="-416" x1="400" />
            <line x2="464" y1="-320" y2="-320" x1="400" />
            <rect width="64" x="400" y="-236" height="24" />
            <line x2="464" y1="-224" y2="-224" x1="400" />
            <rect width="64" x="400" y="-140" height="24" />
            <line x2="464" y1="-128" y2="-128" x1="400" />
            <rect width="64" x="400" y="-44" height="24" />
            <line x2="464" y1="-32" y2="-32" x1="400" />
            <rect width="336" x="64" y="-640" height="704" />
        </blockdef>
        <blockdef name="wb_slave_generic">
            <timestamp>2016-12-8T11:2:17</timestamp>
            <rect width="256" x="64" y="-384" height="384" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-352" y2="-352" x1="320" />
            <rect width="64" x="320" y="-204" height="24" />
            <line x2="384" y1="-192" y2="-192" x1="320" />
            <rect width="64" x="320" y="-44" height="24" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <block symbolname="gpmc_wishbone" name="XLXI_1">
            <blockpin signalname="gpmc_clk_i" name="gpmc_clk_i" />
            <blockpin signalname="gpmc_n_we" name="gpmc_n_we" />
            <blockpin signalname="gpmc_n_oe" name="gpmc_n_oe" />
            <blockpin signalname="gpmc_n_adv_ale" name="gpmc_n_adv_ale" />
            <blockpin signalname="sys_clk_P" name="sys_clk_P" />
            <blockpin signalname="XLXN_8" name="ACK_I" />
            <blockpin signalname="gpmc_a(10:1)" name="gpmc_a(10:1)" />
            <blockpin signalname="gpmc_n_cs(6:0)" name="gpmc_n_cs(6:0)" />
            <blockpin signalname="gpio_in(7:0)" name="gpio_in(7:0)" />
            <blockpin signalname="XLXN_21(15:0)" name="DAT_I(15:0)" />
            <blockpin signalname="gpmc_d(15:0)" name="gpmc_d(15:0)" />
            <blockpin signalname="XLXN_1" name="CLK" />
            <blockpin signalname="XLXN_2" name="RST" />
            <blockpin signalname="XLXN_3" name="STB_O" />
            <blockpin signalname="XLXN_4" name="WE_O" />
            <blockpin signalname="gpio_o(7:0)" name="gpio_out(7:0)" />
            <blockpin signalname="XLXN_23(1:0)" name="ADR_O(1:0)" />
            <blockpin signalname="XLXN_17(15:0)" name="DAT_O(15:0)" />
        </block>
        <block symbolname="wb_slave_generic" name="XLXI_6">
            <blockpin signalname="XLXN_1" name="CLK_I" />
            <blockpin signalname="XLXN_2" name="RST_I" />
            <blockpin signalname="XLXN_3" name="STB_I" />
            <blockpin signalname="XLXN_4" name="WE_I" />
            <blockpin signalname="XLXN_23(1:0)" name="ADR_I(1:0)" />
            <blockpin signalname="XLXN_17(15:0)" name="DAT_I(15:0)" />
            <blockpin signalname="XLXN_8" name="ACK_O" />
            <blockpin signalname="XLXN_21(15:0)" name="DAT_O(15:0)" />
            <blockpin signalname="PRT_O(15:0)" name="PRT_O(15:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1072" y="1168" name="XLXI_1" orien="R0">
        </instance>
        <branch name="XLXN_8">
            <wire x2="1056" y1="448" y2="880" x1="1056" />
            <wire x2="1072" y1="880" y2="880" x1="1056" />
            <wire x2="2656" y1="448" y2="448" x1="1056" />
            <wire x2="2656" y1="448" y2="640" x1="2656" />
            <wire x2="2608" y1="640" y2="640" x1="2592" />
            <wire x2="2656" y1="640" y2="640" x1="2608" />
        </branch>
        <branch name="gpmc_clk_i">
            <wire x2="1056" y1="560" y2="560" x1="1040" />
            <wire x2="1072" y1="560" y2="560" x1="1056" />
        </branch>
        <iomarker fontsize="28" x="1040" y="560" name="gpmc_clk_i" orien="R180" />
        <branch name="gpmc_n_we">
            <wire x2="1056" y1="624" y2="624" x1="1040" />
            <wire x2="1072" y1="624" y2="624" x1="1056" />
        </branch>
        <iomarker fontsize="28" x="1040" y="624" name="gpmc_n_we" orien="R180" />
        <branch name="gpmc_n_oe">
            <wire x2="1056" y1="688" y2="688" x1="1040" />
            <wire x2="1072" y1="688" y2="688" x1="1056" />
        </branch>
        <iomarker fontsize="28" x="1040" y="688" name="gpmc_n_oe" orien="R180" />
        <branch name="gpmc_n_adv_ale">
            <wire x2="1056" y1="752" y2="752" x1="1040" />
            <wire x2="1072" y1="752" y2="752" x1="1056" />
        </branch>
        <iomarker fontsize="28" x="1040" y="752" name="gpmc_n_adv_ale" orien="R180" />
        <branch name="sys_clk_P">
            <wire x2="1056" y1="816" y2="816" x1="1040" />
            <wire x2="1072" y1="816" y2="816" x1="1056" />
        </branch>
        <iomarker fontsize="28" x="1040" y="816" name="sys_clk_P" orien="R180" />
        <branch name="gpmc_a(10:1)">
            <wire x2="944" y1="944" y2="944" x1="928" />
            <wire x2="1056" y1="944" y2="944" x1="944" />
            <wire x2="1072" y1="944" y2="944" x1="1056" />
        </branch>
        <branch name="gpmc_n_cs(6:0)">
            <wire x2="992" y1="1008" y2="1008" x1="976" />
            <wire x2="1056" y1="1008" y2="1008" x1="992" />
            <wire x2="1072" y1="1008" y2="1008" x1="1056" />
        </branch>
        <branch name="gpio_in(7:0)">
            <wire x2="944" y1="1072" y2="1072" x1="928" />
            <wire x2="1056" y1="1072" y2="1072" x1="944" />
            <wire x2="1072" y1="1072" y2="1072" x1="1056" />
        </branch>
        <branch name="gpmc_d(15:0)">
            <wire x2="1552" y1="1136" y2="1136" x1="1536" />
            <wire x2="1568" y1="1136" y2="1136" x1="1552" />
        </branch>
        <iomarker fontsize="28" x="1568" y="1136" name="gpmc_d(15:0)" orien="R0" />
        <branch name="gpio_o(7:0)">
            <wire x2="1552" y1="944" y2="944" x1="1536" />
            <wire x2="1568" y1="944" y2="944" x1="1552" />
        </branch>
        <iomarker fontsize="28" x="1568" y="944" name="gpio_o(7:0)" orien="R0" />
        <iomarker fontsize="28" x="928" y="944" name="gpmc_a(10:1)" orien="R180" />
        <iomarker fontsize="28" x="976" y="1008" name="gpmc_n_cs(6:0)" orien="R180" />
        <iomarker fontsize="28" x="928" y="1072" name="gpio_in(7:0)" orien="R180" />
        <instance x="2208" y="992" name="XLXI_6" orien="R0">
        </instance>
        <branch name="XLXN_1">
            <wire x2="1552" y1="560" y2="560" x1="1536" />
            <wire x2="1552" y1="560" y2="640" x1="1552" />
            <wire x2="2192" y1="640" y2="640" x1="1552" />
            <wire x2="2208" y1="640" y2="640" x1="2192" />
        </branch>
        <branch name="XLXN_2">
            <wire x2="1552" y1="656" y2="656" x1="1536" />
            <wire x2="1552" y1="656" y2="704" x1="1552" />
            <wire x2="2192" y1="704" y2="704" x1="1552" />
            <wire x2="2208" y1="704" y2="704" x1="2192" />
        </branch>
        <branch name="XLXN_3">
            <wire x2="1552" y1="752" y2="752" x1="1536" />
            <wire x2="1552" y1="752" y2="768" x1="1552" />
            <wire x2="2192" y1="768" y2="768" x1="1552" />
            <wire x2="2208" y1="768" y2="768" x1="2192" />
        </branch>
        <branch name="XLXN_4">
            <wire x2="1552" y1="848" y2="848" x1="1536" />
            <wire x2="1552" y1="832" y2="848" x1="1552" />
            <wire x2="2192" y1="832" y2="832" x1="1552" />
            <wire x2="2208" y1="832" y2="832" x1="2192" />
        </branch>
        <branch name="PRT_O(15:0)">
            <wire x2="2608" y1="960" y2="960" x1="2592" />
            <wire x2="2800" y1="960" y2="960" x1="2608" />
        </branch>
        <iomarker fontsize="28" x="2800" y="960" name="PRT_O(15:0)" orien="R0" />
        <branch name="XLXN_17(15:0)">
            <wire x2="1872" y1="1040" y2="1040" x1="1536" />
            <wire x2="1872" y1="960" y2="1040" x1="1872" />
            <wire x2="2208" y1="960" y2="960" x1="1872" />
        </branch>
        <branch name="XLXN_21(15:0)">
            <wire x2="1072" y1="1136" y2="1136" x1="1008" />
            <wire x2="1008" y1="1136" y2="1312" x1="1008" />
            <wire x2="2672" y1="1312" y2="1312" x1="1008" />
            <wire x2="2672" y1="800" y2="800" x1="2592" />
            <wire x2="2672" y1="800" y2="1312" x1="2672" />
        </branch>
        <branch name="XLXN_23(1:0)">
            <wire x2="1552" y1="1200" y2="1200" x1="1536" />
            <wire x2="2048" y1="1200" y2="1200" x1="1552" />
            <wire x2="2160" y1="1200" y2="1200" x1="2048" />
            <wire x2="2160" y1="896" y2="1184" x1="2160" />
            <wire x2="2160" y1="1184" y2="1200" x1="2160" />
            <wire x2="2208" y1="896" y2="896" x1="2160" />
        </branch>
    </sheet>
</drawing>