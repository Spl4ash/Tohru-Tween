--// TohruTween made by Tohru! btw you can make cool forks, just give me credit if you do
--//btw, you can tween tables with this module!

--//The easings of this module are ported from TaroNuke NotITG template, so the easings works just like it!
-->> Port Link: https://www.dropbox.com/s/yksyrxkuf8p38ci/THE%20WORLD%20REVOLVING%20%5BTaroNuke%5D.zip?dl=0&e=1&file_subpath=%2FTHE+WORLD+REVOLVING+%5BTaroNuke%5D%2Flua%2Feasing.lua

--[[

--//[Usage Example]

------

local CoolTable={
	coolProperty=2
}

local newTween=TohruTween.Create({
	name='tweenName';
	object=CoolTable;
	property='coolProperty';
	value=10;
	duration=2;
	ease='outQuad';
})

newTween:Start()

------

--//[Tween Properties]

local example=TohruTween.Create(...)

example.onUpdate=function(elapsed) --// Runs every step hit

end;

example.onCompleted=function() --// Runs after tweens end (does not apply to :Stop function!)

end;

example.ex1, example.ex2 are the extra params of elastic and back eases

]]

local RS=game:GetService('RunService')

local module={}
module.__index=module

local activeTweens={};
export type tweenData={
	name:              string;
	object:            Instance;
	property:          string;
	value:             idk;
	duration:          number;
	ease:              string;
};

---------------------------------------------------------------------------------------
----------------------DON'T TOUCH IT KIDDO---------------------------------------------
---------------------------------------------------------------------------------------

-- Adapted from
-- Tweener's easing functions (Penner's Easing Equations)
-- and http://code.google.com/p/tweener/ (jstweener javascript version)
--

--[[
Disclaimer for Robert Penner's Easing Equations license:

TERMS OF USE - EASING EQUATIONS

Open source under the BSD License.

Copyright © 2001 Robert Penner
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

-- For all easing functions:
-- t = elapsed time
-- b = begin
-- c = change == ending - beginning
-- d = duration (total time)

local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs
local asin  = math.asin

local curveList={};

function curveList.linear(t, b, c, d)
	return c * t / d + b
end

function curveList.inQuad(t, b, c, d)
	t = t / d
	return c * pow(t, 2) + b
end

function curveList.outQuad(t, b, c, d)
	t = t / d
	return -c * t * (t - 2) + b
end

function curveList.inOutQuad(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(t, 2) + b
	else
		return -c / 2 * ((t - 1) * (t - 3) - 1) + b
	end
end

function curveList.outInQuad(t, b, c, d)
	if t < d / 2 then
		return curveList.outQuad (t * 2, b, c / 2, d)
	else
		return curveList.inQuad((t * 2) - d, b + c / 2, c / 2, d)
	end
end

function curveList.inCubic (t, b, c, d)
	t = t / d
	return c * pow(t, 3) + b
end

function curveList.outCubic(t, b, c, d)
	t = t / d - 1
	return c * (pow(t, 3) + 1) + b
end

function curveList.inOutCubic(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * t * t * t + b
	else
		t = t - 2
		return c / 2 * (t * t * t + 2) + b
	end
end

function curveList.outInCubic(t, b, c, d)
	if t < d / 2 then
		return curveList.outCubic(t * 2, b, c / 2, d)
	else
		return curveList.inCubic((t * 2) - d, b + c / 2, c / 2, d)
	end
end

function curveList.inQuart(t, b, c, d)
	t = t / d
	return c * pow(t, 4) + b
end

function curveList.outQuart(t, b, c, d)
	t = t / d - 1
	return -c * (pow(t, 4) - 1) + b
end

function curveList.inOutQuart(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(t, 4) + b
	else
		t = t - 2
		return -c / 2 * (pow(t, 4) - 2) + b
	end
end

function curveList.outInQuart(t, b, c, d)
	if t < d / 2 then
		return curveList.outQuart(t * 2, b, c / 2, d)
	else
		return curveList.inQuart((t * 2) - d, b + c / 2, c / 2, d)
	end
end

function curveList.inQuint(t, b, c, d)
	t = t / d
	return c * pow(t, 5) + b
end

function curveList.outQuint(t, b, c, d)
	t = t / d - 1
	return c * (pow(t, 5) + 1) + b
end

function curveList.inOutQuint(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(t, 5) + b
	else
		t = t - 2
		return c / 2 * (pow(t, 5) + 2) + b
	end
end

function curveList.outInQuint(t, b, c, d)
	if t < d / 2 then
		return curveList.outQuint(t * 2, b, c / 2, d)
	else
		return curveList.inQuint((t * 2) - d, b + c / 2, c / 2, d)
	end
end

function curveList.inSine(t, b, c, d)
	return -c * cos(t / d * (pi / 2)) + c + b
end

function curveList.outSine(t, b, c, d)
	return c * sin(t / d * (pi / 2)) + b
end

function curveList.inOutSine(t, b, c, d)
	return -c / 2 * (cos(pi * t / d) - 1) + b
end

function curveList.outInSine(t, b, c, d)
	if t < d / 2 then
		return curveList.outSine(t * 2, b, c / 2, d)
	else
		return curveList.inSine((t * 2) -d, b + c / 2, c / 2, d)
	end
end

function curveList.inExpo(t, b, c, d)
	if t == 0 then
		return b
	else
		return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001
	end
end

function curveList.outExpo(t, b, c, d)
	if t == d then
		return b + c
	else
		return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
	end
end

function curveList.inOutExpo(t, b, c, d)
	if t == 0 then return b end
	if t == d then return b + c end
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005
	else
		t = t - 1
		return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b
	end
end

function curveList.outInExpo(t, b, c, d)
	if t < d / 2 then
		return curveList.outExpo(t * 2, b, c / 2, d)
	else
		return curveList.inExpo((t * 2) - d, b + c / 2, c / 2, d)
	end
end

function curveList.inCirc(t, b, c, d)
	t = t / d
	return(-c * (sqrt(1 - pow(t, 2)) - 1) + b)
end

function curveList.outCirc(t, b, c, d)
	t = t / d - 1
	return(c * sqrt(1 - pow(t, 2)) + b)
end

function curveList.inOutCirc(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return -c / 2 * (sqrt(1 - t * t) - 1) + b
	else
		t = t - 2
		return c / 2 * (sqrt(1 - t * t) + 1) + b
	end
end

function curveList.outInCirc(t, b, c, d)
	if t < d / 2 then
		return curveList.outCirc(t * 2, b, c / 2, d)
	else
		return curveList.inCirc((t * 2) - d, b + c / 2, c / 2, d)
	end
end

function curveList.inElastic(t, b, c, d, a, p)
	if t == 0 then return b end

	t = t / d

	if t == 1  then return b + c end

	if not p then p = d * 0.3 end

	local s

	if not a or a < abs(c) then
		a = c
		s = p / 4
	else
		s = p / (2 * pi) * asin(c/a)
	end

	t = t - 1

	return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
end

-- a: amplitud
-- p: period
function curveList.outElastic(t, b, c, d, a, p)
	if t == 0 then return b end

	t = t / d

	if t == 1 then return b + c end

	if not p then p = d * 0.3 end

	local s

	if not a or a < abs(c) then
		a = c
		s = p / 4
	else
		s = p / (2 * pi) * asin(c/a)
	end

	return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b
end

-- p = period
-- a = amplitud
function curveList.inOutElastic(t, b, c, d, a, p)
	if t == 0 then return b end

	t = t / d * 2

	if t == 2 then return b + c end

	if not p then p = d * (0.3 * 1.5) end
	if not a then a = 0 end

	local s

	if not a or a < abs(c) then
		a = c
		s = p / 4
	else
		s = p / (2 * pi) * asin(c / a)
	end

	if t < 1 then
		t = t - 1
		return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
	else
		t = t - 1
		return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p ) * 0.5 + c + b
	end
end

-- a: amplitud
-- p: period
function curveList.outInElastic(t, b, c, d, a, p)
	if t < d / 2 then
		return curveList.outElastic(t * 2, b, c / 2, d, a, p)
	else
		return curveList.inElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)
	end
end

function curveList.inBack(t, b, c, d, s)
	if not s then s = 1.70158 end
	t = t / d
	return c * t * t * ((s + 1) * t - s) + b
end

function curveList.outBack(t, b, c, d, s)
	if not s then s = 1.70158 end
	t = t / d - 1
	return c * (t * t * ((s + 1) * t + s) + 1) + b
end

function curveList.inOutBack(t, b, c, d, s)
	if not s then s = 1.70158 end
	s = s * 1.525
	t = t / d * 2
	if t < 1 then
		return c / 2 * (t * t * ((s + 1) * t - s)) + b
	else
		t = t - 2
		return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
	end
end

function curveList.outInBack(t, b, c, d, s)
	if t < d / 2 then
		return curveList.outBack(t * 2, b, c / 2, d, s)
	else
		return curveList.inBack((t * 2) - d, b + c / 2, c / 2, d, s)
	end
end

function curveList.outBounce(t, b, c, d)
	t = t / d
	if t < 1 / 2.75 then
		return c * (7.5625 * t * t) + b
	elseif t < 2 / 2.75 then
		t = t - (1.5 / 2.75)
		return c * (7.5625 * t * t + 0.75) + b
	elseif t < 2.5 / 2.75 then
		t = t - (2.25 / 2.75)
		return c * (7.5625 * t * t + 0.9375) + b
	else
		t = t - (2.625 / 2.75)
		return c * (7.5625 * t * t + 0.984375) + b
	end
end

function curveList.inBounce(t, b, c, d)
	return c - curveList.outBounce(d - t, 0, c, d) + b
end

function curveList.inOutBounce(t, b, c, d)
	if t < d / 2 then
		return curveList.inBounce(t * 2, 0, c, d) * 0.5 + b
	else
		return curveList.outBounce(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
	end
end

function curveList.outInBounce(t, b, c, d)
	if t < d / 2 then
		return curveList.outBounce(t * 2, b, c / 2, d)
	else
		return curveList.inBounce((t * 2) - d, b + c / 2, c / 2, d)
	end
end

function curveList.scale(x, l1, h1, l2, h2)
	return (((x) - (l1)) * ((h2) - (l2)) / ((h1) - (l1)) + (l2))
end

function curveList.mathclamp(val,min,max)
	if val < min then return min end
	if val > max then return max end
	return val
end

---------------------------------------------------------------------------------------
----------------------END DON'T TOUCH IT KIDDO-----------------------------------------
---------------------------------------------------------------------------------------

function module.Create(params:tweenData)
	local this=setmetatable(params::tweenData,module)
	return this
end

function module:Start()
	local isServer=RS:IsServer()
	self.startTime=self.startTime or tick()
	self.finalTime=self.startTime+self.duration
	self.startValue=self.object[self.property]

	self:Stop()

	activeTweens[self.name]=RS[isServer and 'Stepped' or 'RenderStepped']:Connect(function(cDelta,sDelta)
		local elapsed=isServer and sDelta or cDelta
		local curtime=tick()-self.startTime
		local duration=self.duration
		local startstrength=self.startValue
		local diff=self.value - startstrength
		local curve=curveList[self.ease]
		local strength=curve(curtime, startstrength, diff, duration, self.ex1, self.ex2)

		self.object[self.property]=strength

		if tick() > self.finalTime and activeTweens[self.name] then
			self.object[self.property]=self.value
			self.startTime=nil self.finalTime=nil self.startValue=nil
			if self.onCompleted then
				self.onCompleted()
			end
			self:Stop()
		end
		if self.onUpdate then
			self.onUpdate(elapsed)
		end
	end)
end

function module:Stop()
	local activeTween=activeTweens[self.name]
	if activeTween then
		--warn('Disconnected: '..self.name..'!')
		activeTweens[self.name]:Disconnect()
		activeTweens[self.name]=nil;
	end
end

---------------------------------------------------------------------------------------
--------------------------------FAST TWEEENS-----------------------------------------
---------------------------------------------------------------------------------------

local portTypes={
	Alpha={'Transparency';'ImageTransparency';'Alpha';'transparency';'alpha'};
	Angle={'Rotation';'Angle';'rotation';'angle'};
	X={'X','x'};
	Y={'Y','y'};
	Z={'Z','z'};
};

function module:PortVar(type:string)
	if not portTypes[type] then return end
	for i=1,#portTypes[type] do
		local portProperty=portTypes[type][i]
		if self.object[portProperty] then return portProperty end
	end
end

function module.setPortableType(type:string, properties:{})
	portTypes[type]=properties;
end

function module.addPortableType(type:string, property:string)
	table.insert(portTypes[type],property)
end

function module.doTweenVar(property,onUpdate,onCompleted,...)
	local tween=module.Create(...)
	tween.property=tween:PortVar(property) or property;
	tween.onCompleted=onCompleted
	tween.onUpdate=onUpdate
	tween:Start()
end

function module.doFastTween(property:string, tag:String, var:String, value:Dynamic, duration:Float, ease:String, onCompleted:(...any)->(), onUpdate:(delta))
	module.doTweenVar(property,onUpdate,onCompleted,{name=tag;object=var;value=value;duration=duration;ease=ease;})
end
--// properties -> X | Y | Z | Angle | Alpha

function module.doTweenVector(tag:String, var:string, property:string, value:Dynamic, duration:Float, ease:String)
	local prop=var[property]
	local vectorType=typeof(prop)
	local vectors=vectorType=='Vector3' and {'X';'Y';'Z'} or {'X';'Y'};
	local startValue=prop or Vector3.zero
	local toTween={x=startValue.X;y=startValue.Y;z=startValue.Z}
	local curValue=startValue
	for i=1,#vectors do
		local vector:string=vectors[i]
		module.doTweenVar(vector,function(elapsed)
			if not toTween then return end
			curValue=vectorType=='Vector3' and Vector3.new(toTween.x,toTween.y,toTween.z) or Vector2.new(toTween.x,toTween.y)
			var[property]=curValue
		end
		,function()
			toTween=nil;
			vectors=nil;
		end
		,{name=tag..vector;object=toTween;value=value[string.upper(vector)];duration=duration;ease=ease;startTime=tick()})
	end
end

return module
