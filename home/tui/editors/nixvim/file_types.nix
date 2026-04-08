{
  autoGroups = {
    filetypes = { };
  };

  files."ftdetect/terraformft.lua".autoCmd = [
    {
      group = "filetypes";
      event = [
        "BufRead"
        "BufNewFile"
      ];
      pattern = [
        "*.tf"
        " *.tfvars"
        " *.hcl"
      ];
      command = "set ft=terraform";
    }
  ];

  files."ftdetect/bicepft.lua".autoCmd = [
    {
      group = "filetypes";
      event = [
        "BufRead"
        "BufNewFile"
      ];
      pattern = [
        "*.bicep"
        "*.bicepparam"
      ];
      command = "set ft=bicep";
    }
  ];

  #------------------------ verilog by jaanai -----------------------#
  files."ftdetect/verilogft.lua".autoCmd = [
    {
      group = "filetypes";
      event = [
        "BufRead"
        "BufNewFile"
      ];
      pattern = [
        "*.v"
        "*.vh"
      ];
      command = "set ft=verilog";
    }
  ];

  files."ftdetect/systemverilogft.lua".autoCmd = [
    {
      group = "filetypes";
      event = [
        "BufRead"
        "BufNewFile"
      ];
      pattern = [
        "*.sv"
        "*.svh"
      ];
      command = "set ft=systemverilog";
    }
  ];
  ##########################################################
}
