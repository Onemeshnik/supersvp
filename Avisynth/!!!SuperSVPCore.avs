# SuperSVP support vk.com/potplayerms t.me/supersvp
Try{ Core=Core }catch(err){ 
FPS= 36 			GPU= 0		MaskArtefact = 0		#FPS: 1..10 - 1..10X,>10 - target FPS. You can proportionally (targeFPS-originalFPS) decrease CPU load reducing this value. GPU 0 - off | 1(11) - 1st GPU on 1st platform | 12 - 2nd GPU on 1st platform | 21 - 1st GPU on 2nd platform...
Radius= 3 		BADLev= Radius 	BlockSize = 0		#0-3  0-weakest, 3 - best. As I know, usually in original SVP BADLev=Radius , but you can control it manually #MaskArtefact 0 - default, 50 - middle, 200 - strong. Bigger values gives less smoothing; BlockSize 0-8, 0-w32, ol0; 1-w32,ol1; 2-w32; 3-ol; 4-ol1; 5-default 16,ol2; 6-w8,ol0; 7-w8,ol1; 8-w8 . Bigger block faster and less noisy, but small have better smooth.
Pel= 1			Thsad= 66		Mode= 4			#pel 2 is default, higher is slower. The accuracy of the motion estimation. 1 means a precision to the pixel, 2 means a precision to half a pixel, 4 - to quarter pixel (not recommended to use). But Pel=1 is Okay #thsad:200, default, 250 for better quality, 1000 for smooth animation, 65000 for... I do not know, but it used some time ago. Zero means "do not refine, just divide" #mode 1 - каждый ориг кадр используется один раз, остальное - расчётные кадры, 0 - из двух ориг кадров остаётся один, остальные расчётные (объясните, ЗАЧЕМ?! Ведь рассчётные хуже и доп нагрузка на ЦПУ), 2 - каждый ориг кадр дублируется (ЗАЧЕМ?! На выходе фейк уплавнение, нагрузка на ГПУ сильно возрастёт),  3 - по ситуации (дефолт), грузит ЦПУ примерно как 0. Я понимаю, что в сложных сценах может быть оправдан переход в 2 режим, но зачем он торчит в нулевом?! 	
CoarseWidth= 66		WeakGPU= 0	SearchDistance= 66  	#default 1050, higher is slower #WeakGPU if your GPU is overload, 1 means linear:false, 2 - cubic:0; 3 - cubic:0,linear:false . In modern version if SVP decides thay you have weak GPU, it paste only linear:false. Cubic:0 is for previous versions #SearchDistance:0 speeds up, but can looks good on GPU. Developers do not use it in script generator
CoarseType=66		SearchType=2
Algo= 13			Tthreads = 66	 			#13  algo for movies, 2 for animation. There is other algos, but they works bad, imho
OSD= 2			FontColor= $44FFFF00			#OSD=0..2 0 disables messages, 1 shows message OSDtimesec seconds, 2 shows them permanently $8800FFFF		
FontSize= 40		Font="Segoe UI Light"
Super_Override=""								#like {scale:{up:0},gpu:1}
Analyse_Override=""
SmoothFPS_Override=""
wtf="" wtf2="" wtf3=""
#vectors= 3 #2 loads gpu less, but worse quality

SetMemoryMax(2700)
PPcheck=1#WIDTH
PPcheck==1? eval ("""
SetFilterMTMode("ffdshow_source",3)
ffdshow_source()
ConvertToYV12()
global threads=4 #for regular player
""") : eval ("""
global threads=GPU==1? round(1.823 * #CPUS) : #CPUS+1 #valid only for PotPlayer. You can calculate and input numbers of CPU Cores*2 manually
SetFilterMTMode("potplayer_source",3)
potplayer_source()
#ConvertToYV12()
""")}

WTF2=FontColor<$10000? "menwe" : "bolwe"
UseCoarseW= CoarseWidth==66? "" : "width:"+String(CoarseWidth)+","
UseSearchDistance= SearchDistance==66? "" : "distance:"+String(SearchDistance)+"," 
UseCoarseType= CoarseType==66? "" : "type:"+String(CoarseType)+"," 

global threads= tthreads == 66 ? threads : tthreads >100 ? threads+tthreads-100 : tthreads >0 ? tthreads : tthreads<0 ? threads + tthreads : threads

orignum=FrameRateNumerator
origdenom=FrameRateDenominator


bit=GetProcessInfo()
Try{LoadPlugin(""+String(bit)+"\svpflow1.dll")
LoadPlugin(""+String(bit)+"\svpflow2.dll")}
catch(err){LoadPlugin("AviSynth\"+String(bit)+"\svpflow1.dll")
LoadPlugin("AviSynth\"+String(bit)+"\svpflow2.dll")}


#LoadPlugin("C:\Program Files (x86)\SVP 4\plugins\svpflow1.dll")
#LoadPlugin("C:\Program Files (x86)\SVP 4\plugins\svpflow2.dll")
#LoadPlugin("C:\Program Files (x86)\SVP 4\plugins64\svpflow1.dll")
#LoadPlugin("C:\Program Files (x86)\SVP 4\plugins64\svpflow2.dll")
SetFilterMTMode("DEFAULT_MT_MODE",2)
SetFilterMTMode("SVSuper",1)
SetFilterMTMode("SVAnalyse",1)

denum=10000
origframerate=framerate
num=ceil(float(FPS)*denum/Framerate)
framerate>40?eval("""num=1 denum=1""") : ""
FPS <= 10 ? eval("""rate = "num:"+String(FPS)+"" denum=1 num=FPS """) : eval(""" rate = "num:"+String(num)+",den:"+String(denum)+"" """)

weakgpuparam= WeakGPU==1? "linear:false," : WeakGPU==2? "cubic:0," : WeakGPU==3? "linear:false,cubic:0," : ""
gpuid = (gpu>1) ? "gpuid:"+String(gpu)+"," : ""



Radius == 0 ? eval("""
AnalyseMainSearchCoarse="satd:false,"
""") : Radius == 1 ? eval("""
AnalyseMainSearchCoarse="type:2,distance:-6,"
""") : Radius == 2 ? eval("""
AnalyseMainSearchCoarse="distance:-8,"
""") : Radius == -1 ? eval("""
AnalyseMainSearchCoarse="distance:-8,"#okay...
Super_Override=""#like {scale:{up:0},pel:1,gpu:1}
Analyse_Override="{block:{w:32,overlap:0},main:{search:{type:2,distance:0,coarse:{width:530,type:2,distance:-1,satd:false,bad:{range:0}}},refine:[{thsad:200,search:{type:2,distance:0}}]}}}"
SmoothFPS_Override=""
FontColor=$44FFFF00
FontSize=40
Font="Segoe UI Light"
""") : Radius == -2 ? eval("""
AnalyseMainSearchCoarse="distance:-8,"#okay...
Super_Override="{scale:{up:0,down:2},gpu:1,pel:1,full:false}"#like {scale:{up:0},gpu:1}
Analyse_Override="{block:{w:32,overlap:0},main:{search:{type:2,distance:0,coarse:{width:530,type:2,distance:-1,satd:false,bad:{range:0}}},refine:[{thsad:0,search:{type:2,distance:0}}]}}}"
SmoothFPS_Override=""
FontColor=$44FFFF00
FontSize=40
Font="Segoe UI Light"
""") : eval ("""
AnalyseMainSearchCoarse="distance:-12,"
""")

AnalyseMainBADLev=""

BADLev == 0 ? eval("""
AnalyseMainBADLev="range:0"
""") : BADLev == 1 ? eval("""
""") : BADLev == 2 ? eval("""
AnalyseMainBADLev="sad:2000,range:24"
""") : eval ("""
AnalyseMainBADLev="sad:2000"
""")

/*BADLev == 0 ? eval("""
AnalyseMainBADLev="range:0"
""") : BADLev == 1 ? eval("""
AnalyseMainBADLev="range:24"
""") : BADLev == 2 ? eval("""
AnalyseMainBADLev="sad:2000,range:24"
""") : eval ("""
AnalyseMainBADLev="sad:2000,range:24"
""")*/ #i was wrong

pel < 2 ? eval("""
pelparams="pel:1,full:false"
""") : eval("""
pelparams="pel:"+String(pel)+""
""")
AnalyseBlock = BlockSize==0 ? "block:{w:32,overlap:0}," : BlockSize==1 ? "block:{w:32,overlap:1}," : BlockSize==2 ? "block:{w:32}," : BlockSize==3 ? "block:{overlap:0}," : BlockSize==4 ? "block:{overlap:1}," : BlockSize==5 ? "block:{}," : BlockSize==6 ? "block:{w:8,overlap:0}," : BlockSize==7 ? "block:{w:8,overlap:1}," : BlockSize==8 ? "block:{w:8}," : "block:{}," 
BlockSizePx = BlockSize==0 ? "32" : BlockSize==1 ? "28" : BlockSize==2 ? "24" : BlockSize==3 ? "16" : BlockSize==4 ? "14" : BlockSize==5 ? "12" : BlockSize==6 ? "8" : BlockSize==7 ? "7" : BlockSize==8 ? "6" : "12" 

gpuparams = gpu>0 ? "scale:{up:0},gpu:1" : "scale:{up:2},gpu:0"

#MultiplerW=width/DisplayW
#MultiplerH=height/DisplayH
##width*height<DisplayW*DisplayW? OverrideRes=0 : OverrideRes=1
#OverrideRes==1?eval(""" """)
#MultiplerW>MultiplerH? cropstring="width/MultiplerW,height/MultiplerH,c=0.75":cropstring=""
UseThsad=Thsad==66?"":"thsad:"+String(Thsad)+","
UseMaskArtefact=MaskArtefact==0? "" : "area:"+String(round(MaskArtefact*10))+""
global source_width = width
global source_height = height
global crop_string  = ""
global resize_string = ""#BicubicResize(1366,768,b=0,c=0.75)"
global super_params     = Super_Override=="" ? "{"+gpuparams+","+pelparams+"}" : Super_Override
#global analyse_params   = "{"+AnalyseBlock+"main:{search:{type:2,"+SearchDistance+"coarse:{"+CoarseWidth+""+AnalyseMainSearchCoarse+" bad:{"+AnalyseMainBADLev+"}}},refine:[{"+thsad+"}]}}}"
part1="{"+AnalyseBlock+"main:{search:{"+UseSearchDistance+"coarse:{"+UseCoarseType+""+UseCoarseW+""+AnalyseMainSearchCoarse+""
part2="bad:{"+AnalyseMainBADLev+"}},type:"+String(SearchType)+"}},refine:[{"+UseThsad+"search:{}}]}"
global analyse_params = Analyse_Override == "" ? ""+part1+""+part2+"" :  Analyse_Override
usemode= mode==4 ? "3,limits:{m1:0,m2:0}" : mode
global smoothFPS_params = SmoothFPS_Override=="" ? "{"+weakgpuparam+"rate:{"+rate+"},"+gpuid+"algo:"+String(algo)+",mask:{"+String(UseMaskArtefact)+"},scene:{mode:"+String(usemode)+"}}" : SmoothFPS_Override

global demo_Mode=0
global stereo_type=0

########## BEGIN OF base.avs ##########
# This file is a part of SmoothVideo Project (SVP) ver.4
# This is NOT the full AVS script, all used variables are defined via
# JScript code that generates the full script text.


NewWidth = 1366
NewHeight = 768
SourceAspect = float(source_width) / float(source_height)
MyAspect = float(NewWidth) / float(NewHeight)
SourceAspect > MyAspect ? eval("""
ResizedWidth=NewWidth
ResizedHeight=round(float(source_height) * float(NewWidth) / float(source_width) / 2.0) * 2
""") : eval("""
ResizedHeight=NewHeight
ResizedWidth=round(float(source_width) * float(NewHeight) / float(source_height) / 2.0  ) * 2
""")
#resize_string="BicubicResize("+String(ResizedWidth)+","+String(ResizedHeight)+",b=0,c=0.75)"

function interpolate(clip src)
{
	input = crop_string=="" ? src : eval("src."+crop_string)
	input = resize_string=="" ? input : eval("input."+resize_string)

	#MT-MODE-1  #do not remove this line!

	super=SVSuper(input, super_params)
	vectors=SVAnalyse(super, analyse_params, src=input)
	smooth=SVSmoothFPS(input, super, vectors, smoothFPS_params, mt=threads, src=src)

	#MT-MODE-2  #do not remove this line!

	return demo_Mode==0 ? smooth : demo(input,smooth)
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

#override= Analyse_Override=="" || SmoothFPS_Override=="" ||Super_Override=="" ? "" : "OVERRIDE MODE" WTF why dont works
override= Analyse_Override!="" ? "OVERRIDE MODE" : SmoothFPS_Override!="" ? "OVERRIDE MODE" : Super_Override!="" ? "OVERRIDE MODE" : ""
#"Orignumden="+String(orignum)+"/"+String(Origdenom)+"->"+String(FrameRateNumerator)+"/"+String(FrameRateDenominator)+"/8\n" + \  
SourceAspect = float(source_width) / float(source_height)
targetframerate=framerate
OSDtime= OSD==9? (Framecount-1) : round(float(FrameRateNumerator)*OSD/FrameRateDenominator)	


OSD>0? eval("""
fontsize=FontSize*width/1920.0
Subtitle( \
 ""+String(source_width)+"x"+String(source_height)+" "+String(SourceAspect)+" "+String(origframerate)+"*"+String(float(num)/denum)+"="+String(targetframerate)+"("+String(FPS)+") "+override+"\n" + \   
 "Radius:"+String(Radius)+"/3, BADLev:"+String(BADLev)+"/3\n" + \  
 "MaskArtefact:"+String(MaskArtefact)+", Block:"+String(BlockSize)+"/8 "+BlockSizePx+"px\n" + \  
 "GPU:"+String(gpu)+", Mode:"+String(mode)+"/4\n" + \  
 "Pel:"+String(pel)+"/4, Threads:"+String(threads)+"\n" + \  
 "WeakGPU:"+String(weakgpu)+"/3, CoarseWidth:"+String(CoarseWidth)+" SearchDistance:"+String(SearchDistance)+"\n" + \
 "OSD:"+String(OSD)+"sec, OSDframes:"+String(OSDtime)+"\n" , \
         font=Font, size=fontsize, text_color=FontColor, spc=2, lsp=10, last_frame = OSDtime )
Subtitle( \
  ""+Super_Override+"\n" + \
  ""+Analyse_Override+"\n" + \
  ""+SmoothFPS_Override+"\n" + \
  "PPcheck:"+String(PPcheck)+" "+String(wtf)+" "+String(wtf2)+" "+String(wtf3)+"\n" + \
  ""+super_params+"\n" + \
  ""+part1+"\n"  + \
  ""+part2+"\n"  + \
  ""+smoothFPS_params+"\n", \
         font=Font, size=fontsize, text_color=FontColor, spc=2, y= height-9*fontsize, lsp=10, last_frame = OSDtime )
Subtitle( \
  "SuperSVP 190501\n" + \
  "vk.com/potplayerms t.me/supersvp \n", \
         font=Font, size=fontsize*1.2, text_color=FontColor, spc=2, y= height-2*fontsize, lsp=10, align=3, last_frame = OSDtime )
""") : ("")
Space=""+chr(13)+""
WriteFileStart("someinfo.txt", "super_params", "Space", "analyse_params", "Space", "smoothFPS_params")
Prefetch(threads)
/*
190505
Добавлен mode 4, что эквивалентно mode 1.5 в офиц версии СВП. Я точно не могу сказать, как это работает, но по идее это должно переключать режимы между 1 и 2 в зависимости от ситуации. Данный режим не вызывает повышения нагрузки на ЦП и в ряде случаев (вроде бы) ниже. Плюс данный режим застраховывает от возможной кривости mode:1. Я сделал этот режим по умолчанию, может чем-то поможет
Изменена политика потоков ЦП, в режиме ГПУ=0 потоки равны кол-ву ядер процессора+1
Изменены имена переменных и более компактный вид
Добавлена возможность изменения типа для search и coarse, значения 1,2,4 чем больше, тем по идее лучше, но грузит намного больше, и лично я улучшения не видел.


190501
Упростил генератор под себя, более читабельный вид.

190427
Небольшие мелочи в ОСДах - настройка размера, цвета (поддержка прозрачности), типа шрифта.

190424
Более быстрый и корректный скрипт, запись лаконичнее
Исправлена ошибка, приводящая к нарушению генерации скрипта. Рефайн отодвинут, поиску присвоено значение по умолчанию type:2
Debug переименован в OSD, запись по возможности более лаконичная запись
Упрощённая запись ОСДов - если указать 0, то её не будет, если указать 9 - она будет идти вечно, если указать любое другое значение - она будет столько секунд, сколько надо

Как-нибудь сделаю,возможно:
Дружелюбность с ffdshow, плагин авс для сбора сведений о системе (нужно узнать кол-во ядер)
Даунскейл под экран, удаление чёрных полос. Если это на потплеере заработает.
Сведение "ползунка" регулировки к 1 виду. То есть, пусть будет мин параметр 1, макс 64, в зависимости от выбора, будет перестроено качество.
Экспорт всех параметров в текстовой файл
Гуй с помощью avspmod - параметры можно будет править слайдерами и прочим. Но текущий авспмод несовместим

*/