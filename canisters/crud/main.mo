import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Int "mo:base/Int";

actor PostCrud {
	
	type PostId = Int;
	type Post = {
		creator: Principal;
		titulo: Text;
		tipo: Text;
		prefacio: Text;
		autor: Text;
		ubicacion: Text;
	};
    
	stable var postId: PostId = 0;
	let postList = HashMap.HashMap<Text, Post>(0, Text.equal, Text.hash);

	private func generateTaskId() : Int {
		postId += 1;
		return postId;
	};

	public shared (msg) func Alta_Datos(men1: Text, men2: Text, men3: Text, men4: Text, men5: Text) : async () {
		let user: Principal = msg.caller;
		let post = {creator=user; titulo=men1; tipo=men2; prefacio=men3; autor=men4; ubicacion=men5};

		postList.put(Int.toText(generateTaskId()), post);
		Debug.print("¡Nuevo recurso agregado! ID: " # Int.toText(postId));
      	Debug.print("Titulo : " # men1);
      	Debug.print("Tipo : " # men2);
      	Debug.print("Prefacio : " # men3);
      	Debug.print("Autor(es) : " # men4);
      	Debug.print("Ubicación : " # men5);
		return ();
	};

	public query func Consulta_especifica(men: Text) : async ?Post {
		let cont: Int=postId;
		var cnt : Int=0;

        label numberLoop for(i in Iter.range(1, cont)) {
	    	switch (postList.get(Int.toText(i))) 
			{
            	case (?post) 
		      	{
			      	let valor : Text=post.titulo;
					if (valor == men)
					{
				      	Debug.print("Titulo : " # post.titulo);
				      	Debug.print("Tipo : " # post.tipo);
				      	Debug.print("Prefacio : " # post.prefacio);
				      	Debug.print("Autor(es) : " # post.autor);
				      	Debug.print("Ubicación : " # post.ubicacion);
						cnt:=cont;
						break numberLoop;
					}; 
		      	};
		    	case (null){break numberLoop};
			};
		};

	   let post: ?Post=postList.get(Int.toText(cnt-1));
	   return post;						
	};


	public query func Consulta_Datos () : async [(Text, Post)] {
		let postIter : Iter.Iter<(Text, Post)> = postList.entries();
		let postArray : [(Text, Post)] = Iter.toArray(postIter);
		let cont: Int=postId;

        label numberLoop for(i in Iter.range(0, cont)) {
	    	switch (postList.get(Int.toText(i))) 
			{
            	case (?post) 
		      	{
				      	Debug.print("Titulo : " # post.titulo);
				      	Debug.print("Tipo : " # post.tipo);
				      	Debug.print("Prefacio : " # post.prefacio);
				      	Debug.print("Autor(es) : " # post.autor);
				      	Debug.print("Ubicación : " # post.ubicacion);
		      	};
		    	case (null){};
			};
		};
		return postArray;
	};


	public query func Baja_Datos(men: Text) : async Bool {
		let cont: Int=postId;
		var ban: Int=0;

		ban:=0;
        label numberLoop for(i in Iter.range(0, cont)) {
	    	switch (postList.get(Int.toText(i))) 
			{
            	case (?post) 
		      	{
			      	let valor: Text=post.titulo;
					if (valor==men)
					{
						ignore postList.remove(Int.toText(i));
						Debug.print("Recurso eliminado ID: " # Int.toText(i));
				      	Debug.print("Titulo : " # post.titulo);
				      	Debug.print("Tipo : " # post.tipo);
				      	Debug.print("Prefacio : " # post.prefacio);
				      	Debug.print("Autor(es) : " # post.autor);
				      	Debug.print("Ubicación : " # post.ubicacion);
						ban:=1;
						break numberLoop;
					}; 
		      	};
		    	case (null){Debug.print("Recurso NO ENCONTRADO!");break numberLoop};
			};
		};
		if (ban==1)
		{
			return true;
		}
		else
		{
	      	Debug.print("Recurso NO ENCONTRADO!");
			return false;
		}
	};


	public shared (msg) func Cambio_Datos (id: Text, men1: Text, men2: Text, men3: Text, men4: Text, men5: Text) : async Bool {
		let user: Principal = msg.caller;
		let cont: Int=postId;
		var ban: Int=0;

		ban:=0;
        label numberLoop for(i in Iter.range(0, cont)) {
	    	switch (postList.get(Int.toText(i))) 
			{
            	case (?post) 
		      	{
			      	let valor: Text=post.titulo;
					if (valor==id)
					{
						let newPost: Post = {creator=user; titulo=men1; tipo=men2; prefacio=men3; autor=men4; ubicacion=men5};
						postList.put(Int.toText(i), newPost);
						Debug.print("Actualizado Datos ID: " # Int.toText(i));
				      	Debug.print("Titulo : " # men1);
				      	Debug.print("Tipo : " # men2);
				      	Debug.print("Prefacio : " # men3);
				      	Debug.print("Autor(es) : " # men4);
				      	Debug.print("Ubicación : " # men5);
						ban:=1;
						break numberLoop;					
					}; 
		      	};
		    	case (null)	{break numberLoop;};
			};
			
		};

		if (ban==1)
		{
			return true;
		}
		else
		{
	      	Debug.print("Recurso NO ENCONTRADO!");
			return false;
		}
	};

}
