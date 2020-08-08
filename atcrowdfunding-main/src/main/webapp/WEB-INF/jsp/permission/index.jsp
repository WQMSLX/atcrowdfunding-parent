<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <%@include file="/WEB-INF/common/css.jsp" %>
    <style>
        .tree li {
            list-style-type: none;
            cursor: pointer;
        }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/common/top.jsp"/>

<div class="container-fluid">
    <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
            <jsp:include page="/WEB-INF/common/menu.jsp"/>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

            <div class="panel panel-default">
                <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 许可权限管理
                    <div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal">
                        <i class="glyphicon glyphicon-question-sign"></i></div>
                </div>
                <div class="panel-body">
                    <ul id="treeDemo" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%--addModal--%>
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="addModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">添加许可</h4>
            </div>
            <form id="addPermissionForm">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="name">许可名称</label>
                        <input type="hidden" id="addFormPid" name="pid">
                        <input type="text" class="form-control" id="addFormName" name="name" placeholder="请输入许可名称">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="name">许可图标</label>
                        <input type="text" class="form-control" id="addFormIcon" name="icon" placeholder="请输入许可图标">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="name">许可标题</label>
                        <input type="text" class="form-control" id="addFormTitle" name="title" placeholder="请输入许可标题">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="addModalBtn">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- updateModal -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="updateModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">添加许可</h4>
            </div>
            <form id="updatePermissionForm">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="name">许可名称</label>
                        <input type="hidden" id="updateFormId" name="id">
                        <input type="hidden" id="updateFormPid" name="pid">
                        <input type="text" class="form-control" id="updateFormName" name="name" placeholder="请输入许可名称">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="name">许可图标</label>
                        <input type="text" class="form-control" id="updateFormIcon" name="icon" placeholder="请输入许可图标">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="name">许可标题</label>
                        <input type="text" class="form-control" id="updateFormTitle" name="title"
                               placeholder="请输入许可标题">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateModalBtn">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/common/js.jsp" %>
<script type="text/javascript">
    $(function () {
            $(".list-group-item").click(function () {
                if ($(this).find("ul")) {
                    $(this).toggleClass("tree-closed");
                    if ($(this).hasClass("tree-closed")) {
                        $("ul", this).hide("fast");
                    } else {
                        $("ul", this).show("fast");
                    }
                }
            });
            showTree();
        }
    );

    function showTree() {
        let setting = {
            data: {
                simpleData: {
                    enable: true,
                    pIdKey: 'pid',
                },
                key: {
                    url: "xUrl", //指定不存在的地址，这样点击节点时不进行跳转
                    name: "title"
                }
            },
            /*添加复选框*/
            /*            check: {
                            enable: true
                        },*/
            view: {
                addDiyDom: setIcon,
                addHoverDom: addHoverDom,
                removeHoverDom: removeHoverDom,

            }
        };
        let zNodes = {};
        $.get("${PATH}/permission/loadTree", {}, function (result) {
            zNodes = result;
            zNodes.push({"id": "0", "permission": "", "title": "许可权限管理", "icon": "glyphicon glyphicon-cog"});
            $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            let treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);
        });

    }

    function setIcon(treeId, treeNode) {
        $("#" + treeNode.tId + "_ico").removeClass();
        $("#" + treeNode.tId + "_span").before('<span class="' + treeNode.icon + '"></span>');
    }

    function addHoverDom(treeId, treeNode) {
        let aObj = $("#" + treeNode.tId + "_a");
        //禁用链接
        aObj.attr("href", "#");
        aObj.attr("onclick", "return false;");
        //如果按钮组的长度大于<span><a>按钮1</a><a>按钮2</a><a>按钮3</a></span>
        if (treeNode.editNameFlag || $("#btnGroup" + treeNode.tId).length > 0) {
            return;
        }

        let s = '<span id="btnGroup' + treeNode.tId + '">';
        if (treeNode.level === 0) { //根节点
            s +=
                '<a class="btn btn-info dropdown-toggle btn-xs" onclick="addBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        } else if (treeNode.level === 1) { //分支节点
            s +=
                '<a class="btn btn-info dropdown-toggle btn-xs" onclick="updateBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
            if (treeNode.children.length === 0) {
                s +=
                    '<a class="btn btn-info dropdown-toggle btn-xs" onclick="deleteBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
            }
            s +=
                '<a class="btn btn-info dropdown-toggle btn-xs" onclick="addBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        } else if (treeNode.level === 2) { //叶子节点
            s += '<a class="btn btn-info dropdown-toggle btn-xs"  onclick="updateBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
            s +=
                '<a class="btn btn-info dropdown-toggle btn-xs" onclick="deleteBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;" href="#">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
        }
        s += '</span>';
        aObj.after(s);
    }

    //当鼠标移除的时候删除按钮
    function removeHoverDom(treeId, treeNode) {
        $("#btnGroup" + treeNode.tId).remove();

    }

    /*----------------------------------增----------------------------------------*/
    function addBtn(id) {
        $("#addFormPid").val(id);
        $("#addModal").modal({show: true, backdrop: 'static', keyboard: false});
    }

    $("#addModalBtn").click(function () {

        let pid = $("#addFormPid").val();
        let icon = $("#addFormIcon").val();
        let title = $("#addFormTitle").val();
        let name = $("#addFormName").val();
        $.ajax({
            url: "${PATH}/permission/add",
            type: "post",
            data: {pid: pid, icon: icon, title: title, name: name},
            success: function (result) {
                if (result === "ok") {
                    layer.msg("添加成功");
                    showTree();
                } else {
                    layer.msg("添加失败");
                }

            }
        });
        $("#addModal input").val("");
        $("#addModal").modal("hide");
    });

    /*===============================update================================*/
    function updateBtn(id) {
        $.get("${PATH}/permission/get",{id:id},function (result) {
            $("#updateFormId").val(result.id);
            $("#updateFormPid").val(result.pid);
            $("#updateFormIcon").val(result.icon);
            $("#updateFormName").val(result.name);
            $("#updateFormTitle").val(result.title);

            $("#updateModal").modal({
                show:true,
                backdrop: "static",
                keyboard: false
            });
        });
    }

    $("#updateModalBtn").click(function () {
        let id=$("#updateFormId").val();
        let pid=$("#updateFormPid").val();
        let icon=$("#updateFormIcon").val();
        let name=$("#updateFormName").val();
        let title=$("#updateFormTitle").val();

        $.ajax({
            url:"${PATH}/permission/update",
            type:"post",
            data:{id:id,pid:pid,icon:icon,name:name,title:title},
            success:function (result) {
                if(result==="ok"){
                    showTree();
                    layer.msg("修改成功");
                }else{
                    layer.msg("修改失败")
                }

            }
        });
        $("#updateModal").modal("hide");
        $("#updateModal input").val("");
    });
    /*--------------------------------deleteBtn-----------------------------------------------------*/
    function deleteBtn(id) {
        layer.confirm("你确定要删除吗？",{btn:['确定','取消']},function () {
            $.get("${PATH}/permission/delete",{id:id},function (result) {
                if(result==="ok"){
                    layer.msg("删除成功");
                    showTree();
                }else{
                    layer.msg("删除失败");
                }
            })
        },function () {
        });
    }
</script>
</body>
</html>
