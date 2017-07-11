using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplayVertBufferWithPoints : MonoBehaviour {


	public Material m;
	public vBuffer  vBuf;

	void Awake(){
		Live();
	}
	
	public void Live(){

		if( vBuf == null ){
			vBuf = gameObject.GetComponent<vBuffer>();

			vBuf.Live();

			gameObject.GetComponent<vBuffUpdater>().Live();
			gameObject.GetComponent<vBuff_Transform>().Live();
		}

	}
	// Update is called once per frame
	void Update () {

		//print("hmm");
		
	}

	void OnRenderObject(){

		//print("ss");
		m.SetPass(0);

		m.SetBuffer( "_vertBuffer", vBuf._buffer );

		//Graphics.DrawProcedural(MeshTopology.Points, vBuf.vertCount );
		Graphics.DrawProcedural(MeshTopology.Triangles, vBuf.vertCount * 6 );


	}
}
