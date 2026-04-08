_: {
  plugins.luasnip = {
    enable = true;
    settings = {
      enable_autosnippets = true;
      store_selection_keys = "<Tab>";
    };
    # verilog by jaanai
    fromVscode = [
      { }
    ];
  };
  #---------------------- verilog by jaanai ------------------------#
  plugins.friendly-snippets.enable = true;
  extraConfigLua = ''
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    ls.add_snippets("verilog", {
      s({trig = "al", priority = 2000}, {
        t("always @("), i(1, "*"), t({") begin", "\t"}), 
        i(0),  -- 光标默认停在这里，仅保留 1 个空行
        t({"", "end"})
      }),
      s({trig = "if", priority = 2000}, {
        t("if ("), i(1, "condition"), t({") begin", "\t"}), 
        i(0), 
        t({"", "end"})
      }),
      s({trig = "mod", priority = 2000}, {
        t("module "), i(1, "mod_name"), t(" ("), t({"", "\t"}), 
        i(2), 
        t({"", ");", "", "\t"}), 
        i(0), 
        t({"", "endmodule"})
      }),
      s({trig = "el", priority = 2000}, {
        t({"else begin", "\t"}), 
        i(0), 
        t({"", "end"})
      })
    })
    ls.filetype_extend("systemverilog", {"verilog"})
  '';
  #-----------------------------------------------------------------#
}
