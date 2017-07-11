using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplayInstancedMeshWithTriangles : MonoBehaviour {


	public Material m;

	public GameObject MeshToInstance;

	public vBuffer  meshVBuff;
	public tBuffer  meshTBuff;

	public vBuffer  particleVBuff;


	void Awake(){
		Live();
	}
	public void Live(){

		if( particleVBuff == null ){
			particleVBuff = gameObject.GetComponent<vBuffer>();

			particleVBuff.Live();

			gameObject.GetComponent<vBuffUpdater>().Live();
			gameObject.GetComponent<vBuff_Transform>().Live();
		}
		
		meshVBuff = MeshToInstance.GetComponent<vBuffer>();
		meshTBuff = MeshToInstance.GetComponent<tBuffer>();

		meshVBuff.Live();
		meshTBuff.Live();
		

	}

	public void Die(){  }

	void OnRenderObject(){


		m.SetPass(0);

		m.SetInt( "_VertsPerMesh" , meshTBuff.triCount );

		m.SetBuffer( "_vertBuffer", meshVBuff._buffer );
		m.SetBuffer( "_triBuffer", meshTBuff._buffer );
		m.SetBuffer( "_particleBuffer", particleVBuff._buffer );

		Graphics.DrawProcedural(MeshTopology.Triangles, meshTBuff.triCount  * particleVBuff.vertCount );


	}
}
