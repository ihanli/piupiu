function CommunicationMap(canvas)
{
	var top, height, paper;
	
	if(!canvas)
	{
		top = $("#balken_oben").offset().top + $("#balken_oben").height();
		height = $("#balken_unten").offset().top - top;

		$("#canvas").css({"top":top,"left":"0"});
		
		paper = Raphael("canvas", $(".plus_zoom").offset().left, height);
	}
	else
	{
		// paper = Raphael(canvas);
	}
	
	var nodeSet = paper.set();
	var edgeSet = paper.set();
	var tree = new Node();
	tree.isRoot = true;
	var coordBackup = [];
	
	var cycleCount = 0;
	var scale = .25;
	var centerOfParent = {x:0,y:0};
	var positionRelativeToParent = {x:0,y:0};
	var nodeSize = {width:0,height:0};
	var distanceFromParent = {x:0,y:0};
	var gapFactor = 1.6;
	var maxComments = 5;
	var zoom = 1.0;
	
	this.render = function(root)
	{
		if(tree.value)
		{
			cycleCount = 0;
			renderTree(root);
		}
		else
		{
			buildTree(root, tree);
			renderTree(tree);
			nodeSet.attr({"cursor":"pointer"});			
			nodeSet.click(click);
		}
		
		edgeSet.remove();
		drawConnections(tree);
	}
	
	var buildTree = function(json, node)
	{
		if(node.isRoot)
		{
			centerOfParent.x = paper.width / 2 - json.width * scale / 2;
			centerOfParent.y = paper.height / 2 - json.height * scale / 2;
		}
		else
			centerOfParent.x = centerOfParent.y = 0;
	
		var parent = paper.image(json.url, centerOfParent.x, centerOfParent.y, json.width * scale, json.height * scale);
		parent.ancestry = json.id;
		
		nodeSet.push(parent);
		node.value = parent;

		for(i in json.comments)
		{
			node.comments[node.comments.length] = new Node();
			
			if(json.comments[i].comments.length > 0)
			{
				cycleCount++;
				buildTree(json.comments[i], node.comments[node.comments.length - 1]);
			}
			else
			{
				var child = paper.image(json.comments[i].url, 0, 0, json.comments[i].width * scale, json.comments[i].height * scale);
				child.ancestry = json.comments[i].id;
				nodeSet.push(child);
				node.comments[node.comments.length - 1].value = child;
			}
		}
	}
	
	var drawConnections = function(node)
	{		
		for(i in node.comments)
		{
			calcNextNode(node.comments[i], i);
			distanceFromParent.x = nodeSize.width * gapFactor;
			distanceFromParent.y = nodeSize.height * gapFactor;
				
			var line = paper.path("M" + (node.value.attr("x") + node.value.attr("width") / 2) + " " + (node.value.attr("y") + node.value.attr("height") / 2) + "L" + (node.value.attr("x") + distanceFromParent.x * positionRelativeToParent.x + node.comments[i].value.attr("width") / 2) + " " + (node.value.attr("y") + distanceFromParent.y * positionRelativeToParent.y + node.comments[i].value.attr("height") / 2) + "Z");
			line.toBack();
			edgeSet.push(line);
		
			if(node.comments[i].comments.length > 0)
				drawConnections(node.comments[i]);
		}
	}
	
	var calcNextNode = function(comment, rad)
	{
		positionRelativeToParent.x = Math.sin(2 * Math.PI * rad / maxComments);
		positionRelativeToParent.y = Math.cos(2 * Math.PI * rad / maxComments);
			
		nodeSize.width = comment.value.attr("width") * gapFactor;
		nodeSize.height = comment.value.attr("height") * gapFactor;
	}

	this.zoomIn = function()
	{
		zoom += .25;
		nodeSet.scale(zoom, zoom);
		this.render(tree);
	}

	this.zoomOut = function()
	{
		if(zoom > 1)
			zoom -= .25;

		nodeSet.scale(zoom, zoom);
		this.render(tree);
	}
	
	var renderTree = function(node)
	{
		for(i in node.comments)
		{			
			calcNextNode(node.comments[i], i);
			distanceFromParent.x = gapFactor * nodeSize.width;
			distanceFromParent.y = gapFactor * nodeSize.height;
			node.comments[i].value.attr({x:node.value.attr("x") + distanceFromParent.x * positionRelativeToParent.x,y:node.value.attr("y") + distanceFromParent.y * positionRelativeToParent.y});
		
			if(node.comments[i].comments.length > 0)
				renderTree(node.comments[i]);
		}
	}
	
	var click = function(e)
	{
		$("a#popup").attr("href", "");
		$("a#popup").attr({"href":$("a#popup").attr("href") + this.ancestry + "/comment"});
		$("a#popup").trigger("click");
	}
	
	this.start = function(event)
	{
		for(var i = 0;i < nodeSet.length;i++)
			coordBackup[i] = {ox:nodeSet[i].attr("x"), oy:nodeSet[i].attr("y")};
	}
	
	this.move = function(dx, dy)
	{
		for(var i = 0;i < nodeSet.length;i++)
			nodeSet[i].attr({x:coordBackup[i].ox + dx, y:coordBackup[i].oy + dy});

		edgeSet.remove();
		drawConnections(tree);
	}
}