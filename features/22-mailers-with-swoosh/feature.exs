%{
  number: 22,
  slug: "22-mailers-with-swoosh",
  title: "Mailers with Swoosh",
  summary:
    "Swoosh.Email, deliver, Local and Test adapters, mailbox preview, attachments, and HEEx mail templates for flight desks.",
  official: "https://hexdocs.pm/swoosh/Swoosh.html",
  slots: [
    %{
      number: 1,
      slug: "01-medellin-guatape-mailer",
      title: "Medellín Guatapé mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.MedellinGuatapeMailerLive
    },
    %{
      number: 2,
      slug: "02-guayaquil-guayas-mailer",
      title: "Guayaquil Guayas mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.GuayaquilGuayasMailerLive
    },
    %{
      number: 3,
      slug: "03-belem-ver-o-peso-mailer",
      title: "Belém Ver-o-Peso mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.BelemVerOPesoMailerLive
    },
    %{
      number: 4,
      slug: "04-salvador-pelourinho-mailer",
      title: "Salvador Pelourinho mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.SalvadorPelourinhoMailerLive
    },
    %{
      number: 5,
      slug: "05-belo-horizonte-pampulha-mailer",
      title: "Belo Horizonte Pampulha mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.BeloHorizontePampulhaMailerLive
    },
    %{
      number: 6,
      slug: "06-curitiba-wire-mailer",
      title: "Curitiba wire mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.CuritibaWireMailerLive
    },
    %{
      number: 7,
      slug: "07-porto-alegre-gaucho-mailer",
      title: "Porto Alegre gaúcho mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.PortoAlegreGauchoMailerLive
    },
    %{
      number: 8,
      slug: "08-florianopolis-ilha-mailer",
      title: "Florianópolis ilha mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.FlorianopolisIlhaMailerLive
    },
    %{
      number: 9,
      slug: "09-campo-grande-pantanal-mailer",
      title: "Campo Grande Pantanal mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.CampoGrandePantanalMailerLive
    },
    %{
      number: 10,
      slug: "10-luxor-nile-mailer",
      title: "Luxor Nile mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.LuxorNileMailerLive
    },
    %{
      number: 11,
      slug: "11-khartoum-confluence-mailer",
      title: "Khartoum confluence mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.KhartoumConfluenceMailerLive
    },
    %{
      number: 12,
      slug: "12-kumasi-garden-mailer",
      title: "Kumasi garden mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.KumasiGardenMailerLive
    },
    %{
      number: 13,
      slug: "13-lalibela-rock-mailer",
      title: "Lalibela rock mailer",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.LalibelaRockMailerLive
    }
  ]
}
