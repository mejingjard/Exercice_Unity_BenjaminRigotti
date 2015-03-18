// Shader created with Shader Forge Beta 0.23 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.23;sub:START;pass:START;ps:lgpr:1,nrmq:1,limd:1,blpr:0,bsrc:0,bdst:0,culm:2,dpts:2,wrdp:True,uamb:True,mssp:True,ufog:True,aust:True,igpj:False,qofs:0,lico:1,qpre:2,flbk:,rntp:3,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,hqsc:True,hqlp:False,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0.1098039,fgcb:0.1882353,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0;n:type:ShaderForge.SFN_Final,id:1,x:32088,y:32574|diff-3-OUT,emission-42-OUT,amdfl-42-OUT,clip-2-A;n:type:ShaderForge.SFN_Tex2d,id:2,x:32535,y:32267,ptlb:_Diffuse,tex:059a1c44c59f416499102edabfbb64b5,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:3,x:32349,y:32329|A-2-RGB,B-4-RGB;n:type:ShaderForge.SFN_Color,id:4,x:32535,y:32446,ptlb:_TintColor,c1:0.5441177,c2:0.5441177,c3:0.5441177,c4:1;n:type:ShaderForge.SFN_Tex2d,id:24,x:32783,y:32540,ptlb:_GlowMap,tex:4d7b287bc2049f24998a5bc5378f2cc9,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:25,x:32485,y:32789|A-26-RGB,B-27-RGB;n:type:ShaderForge.SFN_Tex2d,id:26,x:32783,y:32728,ptlb:_MagicGlow,tex:bf28ddf6c4d7e494c88a15484c6e34e9,ntxv:0,isnm:False|UVIN-53-UVOUT;n:type:ShaderForge.SFN_Color,id:27,x:32783,y:32914,ptlb:_GlowColor,c1:1,c2:0.7261663,c3:0.007352948,c4:1;n:type:ShaderForge.SFN_Multiply,id:42,x:32485,y:32616|A-24-A,B-25-OUT;n:type:ShaderForge.SFN_Time,id:50,x:33398,y:32613;n:type:ShaderForge.SFN_Slider,id:51,x:33342,y:32769,ptlb:_MagicSpeed,min:-1,cur:0.2108769,max:1;n:type:ShaderForge.SFN_Multiply,id:52,x:33088,y:32661|A-50-T,B-51-OUT;n:type:ShaderForge.SFN_Panner,id:53,x:32938,y:32691,spu:1,spv:0|DIST-52-OUT;proporder:2-4-24-26-27-51;pass:END;sub:END;*/

Shader "Shader Forge/GuardianSet" {
    Properties {
        _Diffuse ("_Diffuse", 2D) = "white" {}
        _TintColor ("_TintColor", Color) = (0.5441177,0.5441177,0.5441177,1)
        _GlowMap ("_GlowMap", 2D) = "white" {}
        _MagicGlow ("_MagicGlow", 2D) = "white" {}
        _GlowColor ("_GlowColor", Color) = (1,0.7261663,0.007352948,1)
        _MagicSpeed ("_MagicSpeed", Range(-1, 1)) = -1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float4 _TintColor;
            uniform sampler2D _GlowMap; uniform float4 _GlowMap_ST;
            uniform sampler2D _MagicGlow; uniform float4 _MagicGlow_ST;
            uniform float4 _GlowColor;
            uniform float _MagicSpeed;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float2 node_76 = i.uv0;
                float4 node_2 = tex2D(_Diffuse,TRANSFORM_TEX(node_76.rg, _Diffuse));
                clip(node_2.a - 0.5);
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor + UNITY_LIGHTMODEL_AMBIENT.xyz;
////// Emissive:
                float4 node_50 = _Time + _TimeEditor;
                float2 node_53 = (node_76.rg+(node_50.g*_MagicSpeed)*float2(1,0));
                float3 node_42 = (tex2D(_GlowMap,TRANSFORM_TEX(node_76.rg, _GlowMap)).a*(tex2D(_MagicGlow,TRANSFORM_TEX(node_53, _MagicGlow)).rgb*_GlowColor.rgb));
                float3 emissive = node_42;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                diffuseLight += node_42; // Diffuse Ambient Light
                finalColor += diffuseLight * (node_2.rgb*_TintColor.rgb);
                finalColor += emissive;
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float4 _TintColor;
            uniform sampler2D _GlowMap; uniform float4 _GlowMap_ST;
            uniform sampler2D _MagicGlow; uniform float4 _MagicGlow_ST;
            uniform float4 _GlowColor;
            uniform float _MagicSpeed;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float2 node_77 = i.uv0;
                float4 node_2 = tex2D(_Diffuse,TRANSFORM_TEX(node_77.rg, _Diffuse));
                clip(node_2.a - 0.5);
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * (node_2.rgb*_TintColor.rgb);
/// Final Color:
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCollector"
            Tags {
                "LightMode"="ShadowCollector"
            }
            Cull Off
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCOLLECTOR
            #define SHADOW_COLLECTOR_PASS
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcollector
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float4 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_COLLECTOR;
                float4 uv0 : TEXCOORD5;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_SHADOW_COLLECTOR(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float2 node_78 = i.uv0;
                float4 node_2 = tex2D(_Diffuse,TRANSFORM_TEX(node_78.rg, _Diffuse));
                clip(node_2.a - 0.5);
                SHADOW_COLLECTOR_FRAGMENT(i)
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Cull Off
            Offset 1, 1
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float4 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float4 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float2 node_79 = i.uv0;
                float4 node_2 = tex2D(_Diffuse,TRANSFORM_TEX(node_79.rg, _Diffuse));
                clip(node_2.a - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
