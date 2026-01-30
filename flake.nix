{
  description = "A collection of flake templates";

  outputs = inputs: {
    templates = {
      python = {
        path = ./python;
        description = "Python template, using uv and venv";
      };
    };
  };
}
