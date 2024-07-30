local TotalNLRTime = 120

if SERVER then
    hook.Add("PlayerDeath", "ShowDeathTimerOnDeath", function(victim, inflictor, attacker)
            
        if IsValid(attacker) and attacker:IsPlayer() then
           victim:SetNWInt("NLR", TotalNLRTime) 
        end
    end)
   
    timer.Create("GlobalNLRTimer", 1, -1, function()
            for PlayerIndex, ply in pairs(player.GetAll()) do
                if ply:GetNWInt("NLR", nil) then
                    if ply:GetNWInt("NLR") <= 0 then ply:SetNWInt("NLR", nil) else
                        ply:SetNWInt("NLR", ply:GetNWInt("NLR")-1)
                    end
                end
            end
    end)
end

if CLIENT then

    local function RealX(x)
        return (x/3440)*ScrW()
    end

    local function RealY(y)
        return (y/1440)*ScrH()
    end


    hook.Add("HUDPaint", "DrawDeathTimer", function()
        if LocalPlayer():GetNWInt("NLR") and LocalPlayer():GetNWInt("NLR") ~= 0 then
            local fraction = math.Clamp(LocalPlayer():GetNWInt("NLR") / TotalNLRTime, 0, 1)
            local green_blue = 255 * (1 - fraction)

            local OuterRing = {
                { x = (ScrW()/4)*2.5, y = 0 },
                { x = ScrW()/4*2.25, y = ScrH()/16 },
                { x = ScrW()/4*1.75, y = ScrH()/16 },
                { x = (ScrW()/4)*1.5, y = 0 },
            }
            local InnerRing = {
                { x = (ScrW()/4)*2.47, y = RealY(3) },
                { x = ScrW()/4*2.25, y = ScrH()/17.7 },
                { x = ScrW()/4*1.75, y = ScrH()/17.7 },
                { x = (ScrW()/4)*1.53, y = RealY(3) },
            }

            surface.SetDrawColor( 255,green_blue,green_blue, 255 )
            draw.NoTexture()
            surface.DrawPoly( OuterRing )
            surface.SetDrawColor( 90, 90, 90, 255 )
            surface.DrawPoly( InnerRing )
            draw.SimpleText("NLR Time Remaining", "HudDefault", ScrW()/2, ScrH()/16/5, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(LocalPlayer():GetNWInt("NLR"), "HudDefault", ScrW()/2, ScrH()/26, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            surface.SetFont( "HudDefault" )
            local linew, _ = surface.GetTextSize( "NLR Time Remaining" )
            draw.RoundedBox(0, (ScrW()/2)-(linew/2), ScrH()/16/2.5, linew, RealY(5), Color(255,green_blue,green_blue))
        end
    end)
end

local vectorpos = Vector(0, 0, 66)

local function DrawName(ply)
    if not IsValid(ply) then return end
    if ply == LocalPlayer() then return end 
    if not ply:Alive() then return end 

    local Distance = LocalPlayer():GetPos():Distance(ply:GetPos()) 

    if Distance < 1000 then 

        local nlrTime = ply:GetNWInt("NLR", 0)
        if nlrTime > 0 then
            local offset = vectorpos
            local ang = LocalPlayer():EyeAngles()
            local pos = ply:GetPos() + offset + ang:Up()

            ang:RotateAroundAxis(ang:Forward(), 90)
            ang:RotateAroundAxis(ang:Right(), 90)

            cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)
                draw.SimpleText("NLR", "CenterPrintText", 0, 0, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end
    end
end

hook.Add("PostPlayerDraw", "DrawName", DrawName)