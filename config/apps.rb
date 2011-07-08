class Imaging < Padrino::Application
  require 'rack_thumb'
  disable :sessions
  disable :flash
  use Rack::Thumb,
    :write => true
  get '/' do
    <<-UNICORN
    <!DOCTYPE html><html lang="en"><head><meta charset="UTF-8" /><title>Invisible Pink Unicorn</title><script>function init(){var canvas=document.getElementById("canvas");var ctx=canvas.getContext("2d");draw(ctx);}
    function draw(ctx){ctx.save();ctx.save();ctx.beginPath();ctx.moveTo(381.2,0.0);ctx.bezierCurveTo(388.8,0.0,396.5,0.0,404.2,0.0);ctx.bezierCurveTo(404.4,0.8,405.0,1.2,406.2,1.0);ctx.bezierCurveTo(452.5,2.3,491.1,15.4,524.2,32.0);ctx.bezierCurveTo(556.9,48.5,587.2,68.7,607.2,96.0);ctx.bezierCurveTo(599.0,98.1,591.1,100.6,584.2,104.0);ctx.bezierCurveTo(531.9,50.5,440.0,7.2,333.2,31.0);ctx.bezierCurveTo(242.6,51.2,180.7,109.1,146.2,183.0);ctx.bezierCurveTo(133.6,190.4,120.8,202.9,110.2,209.0);ctx.bezierCurveTo(152.3,91.1,234.5,13.3,381.2,0.0);ctx.closePath();ctx.fill();ctx.beginPath();ctx.moveTo(458.2,137.0);ctx.bezierCurveTo(460.8,156.7,462.9,177.0,465.2,197.0);ctx.bezierCurveTo(365.3,166.8,241.7,186.2,167.2,223.0);ctx.bezierCurveTo(94.6,258.9,37.6,317.0,11.2,399.0);ctx.bezierCurveTo(9.6,403.8,10.0,413.3,0.2,410.0);ctx.bezierCurveTo(-1.0,400.2,4.1,391.1,7.2,382.0);ctx.bezierCurveTo(30.1,314.5,67.7,261.6,116.2,218.0);ctx.bezierCurveTo(170.6,169.1,253.4,130.6,340.2,126.0);ctx.bezierCurveTo(384.9,123.6,422.0,128.9,458.2,137.0);ctx.closePath();ctx.fill();ctx.beginPath();ctx.moveTo(406.2,589.0);ctx.bezierCurveTo(396.8,589.0,387.5,589.0,378.2,589.0);ctx.bezierCurveTo(377.9,588.2,377.3,587.8,376.2,588.0);ctx.bezierCurveTo(289.9,582.2,225.9,548.3,177.2,496.0);ctx.bezierCurveTo(143.9,460.2,114.5,411.1,103.2,351.0);ctx.bezierCurveTo(99.8,333.1,92.8,300.5,98.2,283.0);ctx.bezierCurveTo(101.0,273.8,116.8,267.6,123.2,263.0);ctx.bezierCurveTo(114.7,370.8,154.8,445.7,212.2,497.0);ctx.bezierCurveTo(267.0,546.0,363.0,583.4,463.2,556.0);ctx.bezierCurveTo(544.3,533.8,607.3,476.1,639.2,404.0);ctx.bezierCurveTo(656.4,365.1,666.5,317.3,661.2,266.0);ctx.bezierCurveTo(656.1,217.7,639.6,179.2,618.2,145.0);ctx.bezierCurveTo(626.9,143.1,631.0,136.5,640.2,135.0);ctx.bezierCurveTo(666.8,177.1,683.3,225.0,686.2,284.0);ctx.bezierCurveTo(689.0,343.0,671.7,396.7,648.2,439.0);ctx.bezierCurveTo(604.6,517.5,519.2,582.7,406.2,589.0);ctx.closePath();ctx.fill();ctx.beginPath();ctx.moveTo(479.2,211.0);ctx.bezierCurveTo(488.2,213.0,497.5,214.7,507.2,216.0);ctx.bezierCurveTo(520.7,337.0,490.4,444.8,406.2,481.0);ctx.bezierCurveTo(403.1,463.5,416.9,463.6,425.2,457.0);ctx.bezierCurveTo(481.0,412.4,492.0,308.5,479.2,214.0);ctx.bezierCurveTo(479.2,213.0,479.2,212.0,479.2,211.0);ctx.closePath();ctx.fill();ctx.beginPath();ctx.moveTo(341.2,400.0);ctx.bezierCurveTo(336.2,400.0,331.2,400.0,326.2,400.0);ctx.bezierCurveTo(326.2,376.7,326.2,353.3,326.2,330.0);ctx.bezierCurveTo(313.2,319.7,299.2,310.3,284.2,302.0);ctx.bezierCurveTo(285.3,296.5,290.0,294.5,291.2,289.0);ctx.bezierCurveTo(308.6,298.3,323.1,310.4,340.2,320.0);ctx.bezierCurveTo(342.2,341.1,340.7,374.0,341.2,400.0);ctx.closePath();ctx.fill();ctx.beginPath();ctx.moveTo(504.2,195.0);ctx.bezierCurveTo(503.4,176.8,500.7,160.4,500.2,142.0);ctx.bezierCurveTo(590.8,109.9,683.4,79.9,773.2,47.0);ctx.bezierCurveTo(775.1,48.7,763.6,53.5,759.2,56.0);ctx.bezierCurveTo(676.4,102.0,588.1,149.9,504.2,195.0);ctx.closePath();ctx.fill();ctx.restore();ctx.restore();}</script></head><body onload="init()"><canvas id="canvas" width="774" height="589"></canvas><style type="text/css" media="screen">canvas {margin: 10px auto; }</style></body></html>
    UNICORN
  end
end
Padrino.configure_apps do
  set :delivery_method, :smtp => {
    :address              => "frenz",
    :port                 => 25,
    :enable_starttls_auto => false
  }
  set :mailer_defaults, :from => "noreply@#{Cfg[:domain]}"
  set :session_secret, "5a46f60cd9f36863c475b15ee1a745fc45d37b22c93434d714e7d94a188c9aaf"
end

Padrino.mount("Machete").to("/").host(/^(?!(admin|www\.admin)).*$/)
Padrino.mount("Admin").to("/").host(/^(?:www\.)?admin\..*$/)
Padrino.mount("Imaging").to('/media/')

#Padrino.mount("Governance").to("/egovernance")
