# SuperSVP support vk.com/potplayerms t.me/supersvp
FPS= 60 			GPU= 0		MaskArtefact = 0		#FPS: 1..10 - 1..10X,>10 - target FPS. You can proportionally (targeFPS-originalFPS) decrease CPU load reducing this value. GPU 0 - off | 1(11) - 1st GPU on 1st platform | 12 - 2nd GPU on 1st platform | 21 - 1st GPU on 2nd platform...
Radius= 2 		BADLev= Radius 	BlockSize = 2		#0-3  0-weakest, 3 - best. As I know, usually in original SVP BADLev=Radius , but you can control it manually #MaskArtefact 0 - default, 50 - middle, 200 - strong. Bigger values gives less smoothing; BlockSize 0-8, 0-w32, ol0; 1-w32,ol1; 2-w32; 3-ol; 4-ol1; 5-default 16,ol2; 6-w8,ol0; 7-w8,ol1; 8-w8 . Bigger block faster and less noisy, but small have better smooth.
Pel= 1			Thsad= 1		Mode= 1			#pel 2 is default, higher is slower. The accuracy of the motion estimation. 1 means a precision to the pixel, 2 means a precision to half a pixel, 4 - to quarter pixel (not recommended to use). But Pel=1 is Okay #thsad:200, default, 250 for better quality, 1000 for smooth animation, 65000 for... I do not know, but it used some time ago. Zero means "do not refine, just divide" #mode 1 - каждый ориг кадр используется один раз, остальное - расчётные кадры, 0 - из двух ориг кадров остаётся один, остальные расчётные (объясните, ЗАЧЕМ?! Ведь рассчётные хуже и доп нагрузка на ЦПУ), 2 - каждый ориг кадр дублируется (ЗАЧЕМ?! На выходе фейк уплавнение, нагрузка на ГПУ сильно возрастёт),  3 - по ситуации (дефолт), грузит ЦПУ примерно как 0. Я понимаю, что в сложных сценах может быть оправдан переход в 2 режим, но зачем он торчит в нулевом?! 	
CoarseWidth= 1		WeakGPU= 0	SearchDistance= 1  	#default 1050, higher is slower #WeakGPU if your GPU is overload, 1 means linear:false, 2 - cubic:0; 3 - cubic:0,linear:false . In modern version if SVP decides thay you have weak GPU, it paste only linear:false. Cubic:0 is for previous versions #SearchDistance:0 speeds up, but can looks good on GPU. Developers do not use it in script generator
Algo= 13			tthreads = 0	 			#13  algo for movies, 2 for animation. There is other algos, but they works bad, imho
OSD= 2			FontColor= $44FFFF00			#OSD=0..2 0 disables messages, 1 shows message OSDtimesec seconds, 2 shows them permanently $8800FFFF		
FontSize= 40		Font="Segoe UI Light"
Super_Override=""								#like {scale:{up:0},gpu:1}
Analyse_Override=""
SmoothFPS_Override=""
wtf="" wtf2="" wtf3=""
#vectors= 3 #2 loads gpu less, but worse quality
Core=0
SetMemoryMax(2700)

PPcheck=1#WIDTH
PPcheck==1? eval ("""
SetFilterMTMode("ffdshow_source",3)
ffdshow_source()
ConvertToYV12()
global threads=7 #for regular player
""") : eval ("""
global threads=GPU==1? round(1.823 * #CPUS) : #CPUS+1 #valid only for PotPlayer. You can calculate and input numbers of CPU Cores*2 manually
SetFilterMTMode("potplayer_source",3)
potplayer_source()
""")
Try{ import("!!!SuperSVPCore.avs") }
catch(err){ import("Avisynth\!!!SuperSVPCore.avs") }
