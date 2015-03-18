// Shader created with Shader Forge Beta 0.36 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.36;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:5,bsrc:0,bdst:4,culm:0,dpts:2,wrdp:False,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0.1082872,fgcb:0.1865672,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:32050,y:32628|diff-4-OUT,diffpow-564-OUT,spec-575-OUT,gloss-575-OUT,normal-370-OUT,emission-127-OUT,amdfl-793-OUT,alpha-793-OUT;n:type:ShaderForge.SFN_Color,id:2,x:32633,y:31994,ptlb:_WaterTint,ptin:__WaterTint,glob:False,c1:0.4742647,c2:0.5103956,c3:0.75,c4:1;n:type:ShaderForge.SFN_Cubemap,id:3,x:32633,y:32162,ptlb:_SkyReflexion,ptin:__SkyReflexion,cube:f466cf7415226e046b096197eb7341aa,pvfc:0;n:type:ShaderForge.SFN_Multiply,id:4,x:32417,y:32100|A-2-RGB,B-3-RGB;n:type:ShaderForge.SFN_Add,id:5,x:32473,y:33119|A-6-RGB,B-88-RGB;n:type:ShaderForge.SFN_Tex2d,id:6,x:32627,y:33008,ptlb:_Waves,ptin:__Waves,tex:9bd3db3bf9a5c7740ae6d1c0cdbc86ed,ntxv:3,isnm:True|UVIN-12-UVOUT;n:type:ShaderForge.SFN_Panner,id:12,x:32790,y:33008,spu:0.08,spv:0.05|DIST-172-OUT;n:type:ShaderForge.SFN_Tex2d,id:88,x:32622,y:33266,ptlb:_Waves_copy,ptin:__Waves_copy,tex:bf28ddf6c4d7e494c88a15484c6e34e9,ntxv:2,isnm:False|UVIN-90-UVOUT;n:type:ShaderForge.SFN_Panner,id:90,x:32777,y:33266,spu:-0.05,spv:0.05|DIST-172-OUT;n:type:ShaderForge.SFN_Fresnel,id:101,x:32801,y:32210;n:type:ShaderForge.SFN_Color,id:115,x:32801,y:32362,ptlb:_RefractionColor,ptin:__RefractionColor,glob:False,c1:0.8640788,c2:0.8684003,c3:0.8970588,c4:1;n:type:ShaderForge.SFN_Multiply,id:116,x:32633,y:32304|A-101-OUT,B-115-RGB;n:type:ShaderForge.SFN_Multiply,id:127,x:32450,y:32354|A-116-OUT,B-128-OUT;n:type:ShaderForge.SFN_Slider,id:128,x:32801,y:32533,ptlb:_RefractionPower,ptin:__RefractionPower,min:0,cur:0.2517677,max:1;n:type:ShaderForge.SFN_Time,id:171,x:33108,y:33039;n:type:ShaderForge.SFN_Multiply,id:172,x:32942,y:33147|A-171-T,B-173-OUT;n:type:ShaderForge.SFN_Slider,id:173,x:33090,y:33319,ptlb:_Wavespeed,ptin:__Wavespeed,min:0,cur:0.1278196,max:1;n:type:ShaderForge.SFN_Vector1,id:189,x:32450,y:32241,v1:0;n:type:ShaderForge.SFN_Vector3,id:369,x:32457,y:33419,v1:0.4491242,v2:0.485843,v3:0.5220588;n:type:ShaderForge.SFN_Multiply,id:370,x:32321,y:33270|A-5-OUT,B-369-OUT;n:type:ShaderForge.SFN_Tex2d,id:554,x:32623,y:32711,ptlb:_FallOff,ptin:__FallOff,tex:4a056241e2722dc46a7262a8e7073fd9,ntxv:0,isnm:False;n:type:ShaderForge.SFN_ValueProperty,id:564,x:32450,y:32520,ptlb:_DiffusePower,ptin:__DiffusePower,glob:False,v1:0.7;n:type:ShaderForge.SFN_ValueProperty,id:575,x:32512,y:32624,ptlb:_Autolight,ptin:__Autolight,glob:False,v1:1;n:type:ShaderForge.SFN_DepthBlend,id:598,x:32623,y:32864|DIST-689-OUT;n:type:ShaderForge.SFN_Distance,id:689,x:32813,y:32838|A-691-XYZ,B-759-XYZ;n:type:ShaderForge.SFN_ViewPosition,id:691,x:32964,y:32739;n:type:ShaderForge.SFN_FragmentPosition,id:759,x:32994,y:32872;n:type:ShaderForge.SFN_Multiply,id:793,x:32435,y:32864|A-554-A,B-598-OUT;proporder:2-3-6-88-115-128-173-554-564-575;pass:END;sub:END;*/

Shader "Shader Forge/Water" {
    Properties {
        __WaterTint ("_WaterTint", Color) = (0.4742647,0.5103956,0.75,1)
        __SkyReflexion ("_SkyReflexion", Cube) = "_Skybox" {}
        __Waves ("_Waves", 2D) = "bump" {}
        __Waves_copy ("_Waves_copy", 2D) = "black" {}
        __RefractionColor ("_RefractionColor", Color) = (0.8640788,0.8684003,0.8970588,1)
        __RefractionPower ("_RefractionPower", Range(0, 1)) = 0.2517677
        __Wavespeed ("_Wavespeed", Range(0, 1)) = 0.1278196
        __FallOff ("_FallOff", 2D) = "white" {}
        __DiffusePower ("_DiffusePower", Float ) = 0.7
        __Autolight ("_Autolight", Float ) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One DstColor
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _CameraDepthTexture;
            uniform float4 _TimeEditor;
            uniform float4 __WaterTint;
            uniform samplerCUBE __SkyReflexion;
            uniform sampler2D __Waves; uniform float4 __Waves_ST;
            uniform sampler2D __Waves_copy; uniform float4 __Waves_copy_ST;
            uniform float4 __RefractionColor;
            uniform float __RefractionPower;
            uniform float __Wavespeed;
            uniform sampler2D __FallOff; uniform float4 __FallOff_ST;
            uniform float __DiffusePower;
            uniform float __Autolight;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 binormalDir : TEXCOORD4;
                float4 projPos : TEXCOORD5;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.tangentDir = normalize( mul( _Object2World, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.binormalDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float4 node_171 = _Time + _TimeEditor;
                float node_172 = (node_171.g*__Wavespeed);
                float2 node_802 = i.uv0;
                float2 node_12 = (node_802.rg+node_172*float2(0.08,0.05));
                float2 node_90 = (node_802.rg+node_172*float2(-0.05,0.05));
                float3 normalLocal = ((UnpackNormal(tex2D(__Waves,TRANSFORM_TEX(node_12, __Waves))).rgb+tex2D(__Waves_copy,TRANSFORM_TEX(node_90, __Waves_copy)).rgb)*float3(0.4491242,0.485843,0.5220588));
                float3 normalDirection =  normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = pow(max( 0.0, NdotL), __DiffusePower) * attenColor + UNITY_LIGHTMODEL_AMBIENT.rgb;
////// Emissive:
                float3 emissive = (((1.0-max(0,dot(normalDirection, viewDirection)))*__RefractionColor.rgb)*__RefractionPower);
///////// Gloss:
                float gloss = __Autolight;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                NdotL = max(0.0, NdotL);
                float3 specularColor = float3(__Autolight,__Autolight,__Autolight);
                float3 specular = (floor(attenuation) * _LightColor0.xyz) * pow(max(0,dot(halfDirection,normalDirection)),specPow) * specularColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                float node_793 = (tex2D(__FallOff,TRANSFORM_TEX(node_802.rg, __FallOff)).a*saturate((sceneZ-partZ)/distance(_WorldSpaceCameraPos.rgb,i.posWorld.rgb)));
                diffuseLight += float3(node_793,node_793,node_793); // Diffuse Ambient Light
                finalColor += diffuseLight * (__WaterTint.rgb*texCUBE(__SkyReflexion,viewReflectDirection).rgb);
                finalColor += specular;
                finalColor += emissive;
/// Final Color:
                return fixed4(finalColor,node_793);
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            ZWrite Off
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _CameraDepthTexture;
            uniform float4 _TimeEditor;
            uniform float4 __WaterTint;
            uniform samplerCUBE __SkyReflexion;
            uniform sampler2D __Waves; uniform float4 __Waves_ST;
            uniform sampler2D __Waves_copy; uniform float4 __Waves_copy_ST;
            uniform float4 __RefractionColor;
            uniform float __RefractionPower;
            uniform float __Wavespeed;
            uniform sampler2D __FallOff; uniform float4 __FallOff_ST;
            uniform float __DiffusePower;
            uniform float __Autolight;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 binormalDir : TEXCOORD4;
                float4 projPos : TEXCOORD5;
                LIGHTING_COORDS(6,7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.tangentDir = normalize( mul( _Object2World, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.binormalDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float4 node_171 = _Time + _TimeEditor;
                float node_172 = (node_171.g*__Wavespeed);
                float2 node_803 = i.uv0;
                float2 node_12 = (node_803.rg+node_172*float2(0.08,0.05));
                float2 node_90 = (node_803.rg+node_172*float2(-0.05,0.05));
                float3 normalLocal = ((UnpackNormal(tex2D(__Waves,TRANSFORM_TEX(node_12, __Waves))).rgb+tex2D(__Waves_copy,TRANSFORM_TEX(node_90, __Waves_copy)).rgb)*float3(0.4491242,0.485843,0.5220588));
                float3 normalDirection =  normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = pow(max( 0.0, NdotL), __DiffusePower) * attenColor;
///////// Gloss:
                float gloss = __Autolight;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                NdotL = max(0.0, NdotL);
                float3 specularColor = float3(__Autolight,__Autolight,__Autolight);
                float3 specular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow) * specularColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * (__WaterTint.rgb*texCUBE(__SkyReflexion,viewReflectDirection).rgb);
                finalColor += specular;
                float node_793 = (tex2D(__FallOff,TRANSFORM_TEX(node_803.rg, __FallOff)).a*saturate((sceneZ-partZ)/distance(_WorldSpaceCameraPos.rgb,i.posWorld.rgb)));
/// Final Color:
                return fixed4(finalColor * node_793,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
