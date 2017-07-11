Shader "Custom/InstanceMeshRender" {

	Properties {
    _CubeMap( "Cube Map" , Cube ) = "white" {}
  }
  
  SubShader{
//    Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
    Cull off
    Pass{

      Blend SrcAlpha OneMinusSrcAlpha // Alpha blending
 
      CGPROGRAM
      #pragma target 5.0
 
      #pragma vertex vert
      #pragma fragment frag
 
      #include "UnityCG.cginc"

      uniform samplerCUBE _CubeMap;



			struct Vert{
			  float used;
			  float3 pos;
			  float3 vel;
			  float3 nor;
			  float2 uv;
			  float3 targetPos;
			  float3 debug;
			};


			StructuredBuffer<Vert> _particleBuffer;
			StructuredBuffer<Vert> _vertBuffer;
			StructuredBuffer<int> _triBuffer;

      uniform int _VertsPerMesh;


            
      //A simple input struct for our pixel shader step containing a position.
      struct varyings {
        float4 pos      : SV_POSITION;
        float3 worldPos : TEXCOORD1;
        float3 nor      : TEXCOORD0;
        float3 eye      : TEXCOORD2;
        float3 debug    : TEXCOORD3;
        float2 uv       : TEXCOORD4;
      };

            
           

            //Our vertex function simply fetches a point from the buffer corresponding to the vertex index
            //which we transform with the view-projection matrix before passing to the pixel program.
            varyings vert (uint id : SV_VertexID){

                varyings o;


                int particleID = id / _VertsPerMesh;
                int idInMesh = id % _VertsPerMesh;

                Vert particle = _particleBuffer[particleID];
                int fID = _triBuffer[idInMesh];
                Vert meshVert = _vertBuffer[fID];

                float3 x = normalize( particle.vel );
                float3 y = normalize( cross( x , float3( 1,0,0)));
                float3 z = normalize( cross( x , y ));


                float3 fPos = meshVert.pos.x * x + meshVert.pos.y * y + meshVert.pos.z * z;
                
                o.worldPos = particle.pos +.1 * fPos;// + float3( 0, float( idInHair)+ offsetID, 0 );//mul( worldMat , float4( v.pos , 1.) ).xyz;

                o.eye = _WorldSpaceCameraPos - o.worldPos;

                o.pos = mul (UNITY_MATRIX_VP, float4(o.worldPos,1.0f));


                o.debug = particle.debug;// v.debug;//normalize(v.pos-v.vel) * .5+.5;//n * .5 + .5;
                o.uv = meshVert.uv;
                o.nor = meshVert.nor;

            
                return o;

            }
 
            //Pixel function returns a solid color for each point.
            float4 frag (varyings v) : COLOR {



                float3 col = v.nor * .5 + .5;//cubeCol * (normalize( eyeRefl )* .5 +.5);//v.debug;//cubeCol * (.6*audio+.7) * float3( 6 , 3 + sin(_Time.x) , 2) * .2;// float3(1,0,0);//v.debug * v.uv.x;//v.nor * .5 + .5;
                return float4( col , 1 );

            }
 
            ENDCG
 
        }
    }
 
    Fallback Off

}
	