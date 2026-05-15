# Template Homebrew formula for docrest.
#
# This file is a STARTING POINT. It is not a published formula — copy it into
# your tap repository (e.g. `homebrew-docrest/Formula/docrest.rb`) and then:
#
#   1. Replace `url` with the tarball URL of your GitHub release tag.
#   2. Update `sha256` with the SHA256 of that tarball
#      (`shasum -a 256 docrest-X.Y.Z.tar.gz`).
#   3. Replace the `# RESOURCES START` / `# RESOURCES END` block with the
#      output of `packaging/homebrew/generate_resources.sh`.
#
# Users will then install with:
#   brew tap <github-user>/docrest
#   brew install docrest
#
class Docrest < Formula
  include Language::Python::Virtualenv

  desc "Convert documentation between formats (md, docx, pdf, txt, diagrams)"
  homepage "https://github.com/REPLACE_ME/docrest"
  url "https://github.com/REPLACE_ME/docrest/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "MIT"

  # Dependencies must be alphabetically ordered for `brew style`.
  depends_on "pandoc" # required for md <-> docx, docx -> pdf
  depends_on "pango"  # WeasyPrint runtime dependency for PDF output
  depends_on "python@3.13"

  # mmdc (Mermaid CLI) and plantuml are optional and installed at runtime via
  # `docrest install`, since neither has a stable Homebrew-only path that
  # avoids extra runtimes (Node.js / Java) you might not want pulled in.

  # RESOURCES START
  resource "typer" do
    url "https://files.pythonhosted.org/packages/e4/51/9aed62104cea109b820bbd6c14245af756112017d309da813ef107d42e7e/typer-0.25.1.tar.gz"
    sha256 "9616eb8853a09ffeabab1698952f33c6f29ffdbceb4eaeecf571880e8d7664cc"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49" 
  end

  resource "python-docx" do
    url "https://files.pythonhosted.org/packages/a9/f7/eddfe33871520adab45aaa1a71f0402a2252050c14c7e3009446c8f4701c/python_docx-1.2.0.tar.gz"
    sha256 "7bc9d7b7d8a69c9c02ca09216118c86552704edc23bac179283f2e38f86220ce"
  end

  resource "pypandoc" do
    url "https://files.pythonhosted.org/packages/ea/d6/410615fc433e5d1eacc00db2044ae2a9c82302df0d35366fe2bd15de024d/pypandoc-1.17.tar.gz"
    sha256 "51179abfd6e582a25ed03477541b48836b5bba5a4c3b282a547630793934d799"
  end

  resource "weasyprint" do
    url "https://files.pythonhosted.org/packages/db/3e/65c0f176e6fb5c2b0a1ac13185b366f727d9723541babfa7fa4309998169/weasyprint-68.1.tar.gz"
    sha256 "d3b752049b453a5c95edb27ce78d69e9319af5a34f257fa0f4c738c701b4184e"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/bf/58/6dd97d78a4b17a7a6b9d1c6ad23895abc41f0fdc49c553cc05bdfdcc36d0/pypdf-6.11.0.tar.gz"
    sha256 "062b51c81b0910e6d2755e99e1c5547a0a23b7d0a32322af66240d8edcfabe87"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end
  # RESOURCES END


  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "docrest #{version}", shell_output("#{bin}/docrest --version")
    assert_match "Supported", shell_output("#{bin}/docrest formats")
    (testpath/"hello.md").write("# hello\n\nworld\n")
    system bin/"docrest", "convert", testpath/"hello.md", testpath/"hello.txt"
    assert_path_exists testpath/"hello.txt"
  end
end