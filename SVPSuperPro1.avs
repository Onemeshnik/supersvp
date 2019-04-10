# Script by Dreamject 0.2b, СуперПРО версия SVP. t.me/supersvp vk.me/join/AJQ1d1YbwAreWydK1aGENoWn . Full version of SVP svp-team.com
#Внизу есть какая-то информация по небольшому дебаггингу, поправьте плз, хз как выводить нормально и ресурсонезатратно текст
fps= 60 #1..10 - 1..10X,>10 - target FPS. You can proportionally (targefps-originalfps) decrease CPU load reducing this value
artefactremove = 0 #0 - default, 50 - middle, 200 - strong. Bigger values gives less smoothing
SearchCoarse= 1 #1-4  0-weakest, 3 - best
SearchCoarseBad=SearchCoarse #1-4  0-weakest, 3 - best. As I know, usually in original SVP SearchCoarseBad=SearchCoarse , but you can control it manually
AnalyseBlockP=0#0-8 block size, 0-w32, ol0; 1-w32,ol1; 2-w32; 3-ol; 4-ol1; 5-default 16,ol2; 6-w8,ol0; 7-w8,ol1; 8-w8 . Bigger block faster and less noisy, but small have better smooth.
CoarseWidth="width:530,"#default 1050, higher is slower
weakgpu= 0#if your GPU is overload, 1 means linear:false, 2 - cubic:0; 3 - cubic:0,linear:false . In modern version if SVP decides thay you have weak GPU, it paste only linear:false. Cubic:0 is for previous versions
pel= 1 # 2 is default, higher is slower. The accuracy of the motion estimation. 1 means a precision to the pixel, 2 means a precision to half a pixel, 4 - to quarter pixel (not recommended to use). But pel=1 is Okay
SearchDistance="distance:0," #"distance:0," speeds up, but can looks good on GPU
thsad="thsad:200"#200 default, 250 for better quality, 1000 for smooth animation
algo="13"#13  algo for movies, 2 for animation. There is other algos, but they works bad, imho
gpu= 1 #  0 - off | 1(11) - 1st GPU on 1st platform | 12 - 2nd GPU on 1st platform | 21 - 1st GPU on 2nd platform...
mode= 1 #1 - каждый ориг кадр используется один раз, остальное - расчётные кадры, 0 - из двух ориг кадров остаётся один, остальные расчётные (объясните, ЗАЧЕМ?! Ведь рассчётные хуже и доп нагрузка на ЦПУ), 2 - каждый ориг кадр дублируется (ЗАЧЕМ?! На выходе фейк уплавнение, нагрузка на ГПУ сильно возрастёт),  3 - по ситуации (дефолт), грузит ЦПУ примерно как 0. Я понимаю, что в сложных сценах может быть оправдан переход в 2 режим, но зачем он торчит в нулевом?!
#vectors=3#2 loads gpu less, but worse quality

SetMemoryMax(2700)
global threads=#CPUS * 2 #valid only for PotPlayer. You can calculate and input numbers of CPU cores*2 manually
#global threads=4 #for regular player


LoadPlugin("svpflow1.dll")
LoadPlugin("svpflow2.dll")
SetFilterMTMode("DEFAULT_MT_MODE",2)
SetFilterMTMode("SVSuper",1)
SetFilterMTMode("SVAnalyse",1)
SetFilterMTMode("potplayer_source",3)
#SetFilterMTMode("ffdshow_source",3)
potplayer_source()
#ffdshow_source()
fps <= 10 ? eval("""rate = "num:"+String(fps)+",den:1" """) : eval(""" rate = "num:"+String(fps)+",den:1,abs:true" """)

weakgpuparam= weakgpu==1? "linear:false," : weakgpu==2? "cubic:0," : weakgpu==3? "linear:false,cubic:0," : ""
gpuid = (gpu>1) ? "gpuid:"+String(gpu)+"," : ""
#Объявляем переменные	

AnalyseMainSearchCoarse=""
AnalyseMainSearchCoarseDistance=""


SearchCoarse == 0 ? eval("""
AnalyseMainSearchCoarse="satd:false,"
""") : SearchCoarse == 1 ? eval("""
AnalyseMainSearchCoarse="type:2,distance:-6,"
""") : SearchCoarse == 2 ? eval("""
AnalyseMainSearchCoarse="distance:-8,"
""") : eval ("""
AnalyseMainSearchCoarse="distance:-12,"
""")

AnalyseMainSearchCoarseBad=""

SearchCoarseBad == 0 ? eval("""
AnalyseMainSearchCoarseBad="range:0"
""") : SearchCoarseBad == 1 ? eval("""
""") : SearchCoarseBad == 2 ? eval("""
AnalyseMainSearchCoarseBad="sad:2000,range:24"
""") : eval ("""
AnalyseMainSearchCoarseBad="sad:2000"
""")

pel < 2 ? eval("""
pelparams="pel:1,full:false"
""") : eval("""
pelparams="pel:"+String(pel)+""
""")
AnalyseBlock = AnalyseBlockP==0 ? "block:{w:32,overlap:0}," : AnalyseBlockP==1 ? "block:{w:32,overlap:1}," : AnalyseBlockP==2 ? "block:{w:32}," : AnalyseBlockP==3 ? "block:{overlap:0}," : AnalyseBlockP==4 ? "block:{overlap:1}," : AnalyseBlockP==5 ? "block:{}," : AnalyseBlockP==6 ? "block:{w:8,overlap:0}," : AnalyseBlockP==7 ? "block:{w:8,overlap:1}," : AnalyseBlockP==8 ? "block:{w:8}," : "block:{}," 
gpuparams = gpu>0 ? "scale:{up:0},gpu:1" : "scale:{up:2},gpu:0"
global source_width = width
global source_height = height
global crop_string  = ""
global resize_string = ""
global super_params     = "{"+gpuparams+","+pelparams+"}"
global analyse_params   = "{"+AnalyseBlock+"main:{search:{"+SearchDistance+"coarse:{"+CoarseWidth+""+AnalyseMainSearchCoarse+" bad:{"+AnalyseMainSearchCoarseBad+"}}},refine:[{"+thsad+"}]}}}"
global smoothfps_params = "{"+weakgpuparam+"rate:{"+rate+"},"+gpuid+"algo:"+algo+",mask:{area:"+String(artefactremove)+"},scene:{mode:"+String(mode)+"}}"

global demo_mode=0
global stereo_type=0

########## BEGIN OF base.avs ##########
# This file is a part of SmoothVideo Project (SVP) ver.4
# This is NOT the full AVS script, all used variables are defined via
# JScript code that generates the full script text.

function interpolate(clip src)
{
	input = crop_string=="" ? src : eval("src."+crop_string)
	input = resize_string=="" ? input : eval("input."+resize_string)

	#MT-MODE-1  #do not remove this line!

	super=SVSuper(input, super_params)
	vectors=SVAnalyse(super, analyse_params, src=input)
	smooth=SVSmoothFps(input, super, vectors, smoothfps_params, mt=threads, src=src)

	#MT-MODE-2  #do not remove this line!

	return demo_mode==0 ? smooth : demo(input,smooth)
}

input=last

	stereo_type==0 ? eval(""" interpolate(input)
""") : 	stereo_type==1 ? eval("""
		lf = interpolate(input.crop(0,0,input.width/2,0))
		rf = interpolate(input.crop(input.width/2,0,0,0))
		StackHorizontal(lf, rf)
""") : 	stereo_type==2 ? Eval("""
		lf = interpolate(input.crop(0,0,0,input.height/2))
		rf = interpolate(input.crop(0,input.height/2,0,0))
		StackVertical(lf, rf)""") : input

########### END OF base.avs ###########


#OverlayText = "PotPlayer:"+super_params+""+chr(13)+
#\""+analyse_params+""+chr(13)+
#\""+smoothfps_params+"
#"




#t_mask = messageclip(OverlayText, width=#WIDTH, #height=#HEIGHT).converttoyv12().coloryuv(levels="tv->pc").trim(0,1)
#t_blank = blankclip(t_mask, color=$ffffff)

#t_mask_bl = t_mask.blur(1.0).blur(1.0).blur(1.0)

#overlay(last, t_mask_bl)

#frameevaluate("ol_x_offset = 0")
#frameevaluate("ol_y_offset = #HEIGHT - 100")

#fadeio(15)

return last

Prefetch(threads)